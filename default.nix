{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.musnix;

  kernelConfigLatencyTOP = ''
    LATENCYTOP y
    SCHEDSTATS y
  '';

  kernelConfigOptimize = ''
    IOSCHED_DEADLINE y
    DEFAULT_DEADLINE y
    DEFAULT_IOSCHED "deadline"
    HPET_TIMER y
    TREE_RCU_TRACE n
  '';
  # PREEMPT y is set below

  kernelConfigRealtime = ''
    PREEMPT_RT_FULL y
    PREEMPT y
  '';

  kernelDebug = ''
    KGDB y
  '';

  kernelSources = rec {
    version = "3.14.31";
    src = pkgs.fetchurl {
      url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
      sha256 = "a6dd667bde3eab17ccd7dc0af1fc1e8188dc12295f11c2e18113905f830b47c8";
    };
  };

  realtimePatch = rec {
    version = "rt28";
    kversion = "3.14.31";
    name = "rt-${kversion}-${version}";
    patch = pkgs.fetchurl {
      url = "https://www.kernel.org/pub/linux/kernel/projects/rt/3.14/patch-${kversion}-${version}.patch.xz";
      sha256 = "0aafc2e25dbfcb98f678276b30bd681b07209452269538ab7e268967d9fda03e";
    };
  };

in

{
  options = {
    musnix = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable musnix, a module for real-time audio.
        '';
      };

      kernel.latencytop = mkOption {
        type = types.bool;
        default = false;
        description = ''
          WARNING: Enabling this option will rebuild your kernel.

          If enabled, this option will configure the kernel to use a
          latency tracking infrastructure that is used by the
          "latencytop" userspace tool.
        '';
      };

      kernel.optimize = mkOption {
        type = types.bool;
        default = false;
        description = ''
          WARNING: Enabling this option will rebuild your kernel.

          If enabled, this option will configure the kernel to be
          preemptible, to use the deadline I/O scheduler, and to use
          the High Precision Event Timer (HPET).
        '';
      };

      kernel.realtime = mkOption {
        type = types.bool;
        default = false;
        description = ''
          WARNING: Enabling this option will rebuild your kernel.

          If enabled, this option will apply the CONFIG_PREEMPT_RT
          patch to the kernel.
        '';
      };

      kernel.debug = mkOption {
        type = types.bool;
        default = false;
        description = ''
          WARNING: Enabling this option will rebuild your kernel.

          If enabled, this option will enable the KGDB, or the
          kernel debugger. This is used to debug the realtime
          kernel and should ONLY be enabled if the user knows
          how to use it or has been instructed to use it.
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
        example = "$00:1b.0";
        description = ''
          The PCI ID of the primary soundcard. Used to set the PCI
          latency timer.

          To find the PCI ID of your soundcard:
              lspci | grep -i audio
        '';
      };
    };
  };

  config = mkIf (config.sound.enable && cfg.enable) {
    boot = {
      kernel.sysctl = { "vm.swappiness" = 10; };

      kernelModules =
        if cfg.alsaSeq.enable
          then [ "snd-seq"
                 "snd-rawmidi"
               ]
          else [];

      kernelPackages =
        let
          rtKernel =
            pkgs.linux_3_14.override {
              argsOverride = kernelSources;
              kernelPatches = [ realtimePatch ];
              extraConfig = kernelConfigRealtime
                            + optionalString cfg.kernel.optimize kernelConfigOptimize
                            + optionalString cfg.kernel.latencytop kernelConfigLatencyTOP
                            + optionalString cfg.kernel.debug kernelDebug;
            };
          stdKernel =
            if cfg.kernel.optimize
              then pkgs.linux.override {
                extraConfig = "PREEMPT y\n"
                              + kernelConfigOptimize
                              + optionalString cfg.kernel.latencytop kernelConfigLatencyTOP
                              + optionalString cfg.kernel.debug kernelDebug;
              }
              else if cfg.kernel.latencytop
                then pkgs.linux.override { extraConfig = kernelConfigLatencyTOP; }
                else pkgs.linux;
        in if cfg.kernel.realtime
          then pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor rtKernel pkgs.linuxPackages_3_14)
          else pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor stdKernel pkgs.linuxPackages);

      kernelParams = [ "threadirq" ];

      postBootCommands = ''
        echo 2048 > /sys/class/rtc/rtc0/max_user_freq
        echo 2048 > /proc/sys/dev/hpet/max-user-freq
      '' + optionalString (cfg.soundcardPciId != "") ''
        setpci -v -d *:* latency_timer=b0
        setpci -v -s ${cfg.soundcardPciId} latency_timer=ff
      '';
    };

    environment.systemPackages =
      if cfg.ffado.enable
        then [ pkgs.ffado ]
        else [];

    environment.variables = {
      VST_PATH = "$HOME/.vst:$HOME/.nix-profile/lib/vst:/run/current-system/sw/lib/vst";
      LXVST_PATH = "$HOME/.lxvst:$HOME/.nix-profile/lib/lxvst:/run/current-system/sw/lib/lxvst";
      LADSPA_PATH = "$HOME/.ladspa:$HOME/.nix-profile/lib/ladspa:/run/current-system/sw/lib/ladspa";
      LV2_PATH = "$HOME/.lv2:$HOME/.nix-profile/lib/lv2:/run/current-system/sw/lib/lv2";
      DSSI_PATH = "$HOME/.dssi:$HOME/.nix-profile/lib/dssi:/run/current-system/sw/lib/dssi";
    };

    powerManagement.cpuFreqGovernor = "performance";

    security.pam.loginLimits = [
      { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
      { domain = "@audio"; item = "rtprio"; type = "-"; value = "99"; }
      { domain = "@audio"; item = "nofile"; type = "soft"; value = "99999"; }
      { domain = "@audio"; item = "nofile"; type = "hard"; value = "99999"; }
    ];

    services.udev = {
      packages =
        if cfg.ffado.enable
          then [ pkgs.ffado ]
          else [];

      extraRules = ''
        KERNEL=="rtc0", GROUP="audio"
        KERNEL=="hpet", GROUP="audio"
      '';
    };

    users.extraGroups= { audio = {}; };
  };
}
