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
      kernelParams = [ "threadirq" ];
      postBootCommands = optionalString (cfg.soundcardPciId != "") ''
        ${pkgs.pciutils}/bin/setpci -v -d *:* latency_timer=b0
        ${pkgs.pciutils}/bin/setpci -v -s ${cfg.soundcardPciId} latency_timer=ff
      '';
    };

    environment.systemPackages =
      if cfg.ffado.enable
        then [ pkgs.ffadoFull ]
        else [];

    environment.variables = {
      DSSI_PATH   = "$HOME/.dssi:$HOME/.nix-profile/lib/dssi:/run/current-system/sw/lib/dssi";
      LADSPA_PATH = "$HOME/.ladspa:$HOME/.nix-profile/lib/ladspa:/run/current-system/sw/lib/ladspa";
      LV2_PATH    = "$HOME/.lv2:$HOME/.nix-profile/lib/lv2:/run/current-system/sw/lib/lv2";
      LXVST_PATH  = "$HOME/.lxvst:$HOME/.nix-profile/lib/lxvst:/run/current-system/sw/lib/lxvst";
      VST_PATH    = "$HOME/.vst:$HOME/.nix-profile/lib/vst:/run/current-system/sw/lib/vst";
      VST3_PATH   = "$HOME/.vst3:$HOME/.nix-profile/lib/vst3:/run/current-system/sw/lib/vst3";
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
          then [ pkgs.ffadoFull ]
          else [];
      extraRules = ''
        KERNEL=="rtc0", GROUP="audio"
        KERNEL=="hpet", GROUP="audio"
      '';
    };

    users.extraGroups = { audio = {}; };
  };
}
