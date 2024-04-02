{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.musnix;

in {
  options.musnix = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable musnix, a module for real-time audio.
      '';
    };
    alsaSeq.enable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        If enabled, load ALSA Sequencer kernel modules.  Currently,
        this only loads the `snd_seq` and `snd_rawmidi` modules.
      '';
    };
    ffado.enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        If enabled, use the Free FireWire Audio Drivers (FFADO).
      '';
    };
    rtcqs.enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        If enabled, install the rtcqs command-line utility, which analyzes
        the system and makes suggestions about what to change to make it more
        audio-friendly.  See
        https://wiki.linuxaudio.org/wiki/system_configuration#rtcqs
      '';
    };
    soundcardPciId = mkOption {
      type = types.str;
      default = "";
      example = "00:1b.0";
      description = ''
        The PCI ID of the primary soundcard. Used to set the PCI
        latency timer.

        To find the PCI ID of your soundcard:
            lspci | grep -i audio
      '';
    };
  };

  config = mkIf cfg.enable {
    boot = {
      kernel.sysctl = { "vm.swappiness" = 10; };
      kernelModules =
        if cfg.alsaSeq.enable
          then [ "snd-seq"
                 "snd-rawmidi"
               ]
          else [];
      kernelParams = [ "threadirqs" ];
      postBootCommands = optionalString (cfg.soundcardPciId != "") ''
        ${pkgs.pciutils}/bin/setpci -v -d *:* latency_timer=b0
        ${pkgs.pciutils}/bin/setpci -v -s ${cfg.soundcardPciId} latency_timer=ff
      '';
    };

    environment.systemPackages = let
        rtcqs = pkgs.callPackage ../pkgs/rtcqs.nix {};
      in
        (if cfg.ffado.enable then [ pkgs.ffado ] else []) ++
        (if cfg.rtcqs.enable then [ rtcqs ] else []);

    environment.variables = let
      makePluginPath = format:
        (makeSearchPath format [
          "$HOME/.nix-profile/lib"
          "/run/current-system/sw/lib"
          "/etc/profiles/per-user/$USER/lib"
        ])
        + ":$HOME/.${format}";
    in {
      DSSI_PATH   = lib.mkDefault (makePluginPath "dssi");
      LADSPA_PATH = lib.mkDefault (makePluginPath "ladspa");
      LV2_PATH    = lib.mkDefault (makePluginPath "lv2");
      LXVST_PATH  = lib.mkDefault (makePluginPath "lxvst");
      VST_PATH    = lib.mkDefault (makePluginPath "vst");
      VST3_PATH   = lib.mkDefault (makePluginPath "vst3");
    };

    powerManagement.cpuFreqGovernor = "performance";

    security.pam.loginLimits = [
      { domain = "@audio"; item = "memlock"; type = "-"   ; value = "unlimited"; }
      { domain = "@audio"; item = "rtprio" ; type = "-"   ; value = "99"       ; }
      { domain = "@audio"; item = "nofile" ; type = "soft"; value = "99999"    ; }
      { domain = "@audio"; item = "nofile" ; type = "hard"; value = "99999"    ; }
    ];

    services.udev = {
      packages =
        if cfg.ffado.enable
          then [ pkgs.ffado ]
          else [];
      extraRules = ''
        KERNEL=="rtc0", GROUP="audio"
        KERNEL=="hpet", GROUP="audio"
        DEVPATH=="/devices/virtual/misc/cpu_dma_latency", OWNER="root", GROUP="audio", MODE="0660"
      '';
    };
  };
}
