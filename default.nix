{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.musnix;

  kernelConfigOptimize = ''
    IOSCHED_DEADLINE y
    DEFAULT_DEADLINE y
    DEFAULT_IOSCHED "deadline"
    HPET_TIMER y
    CPU_FREQ n
    TREE_RCU_TRACE n
  '';

  kernelConfigRealtime = ''
    PREEMPT_RT_FULL y
    PREEMPT y
  '';

  kernelSources = rec {
    version = "3.14.25";
    src = pkgs.fetchurl {
      url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
      sha256 = "422aef95cfb89d7a13fe4ce5d12424124598914b1c09e323fae5c958b98ffc1f";
    };
  };

  realtimePatch = rec {
    version = "rt22";
    kversion = "3.14.25";
    name = "rt-${kversion}-${version}";
    patch = pkgs.fetchurl {
      url = "https://www.kernel.org/pub/linux/kernel/projects/rt/3.14/patch-${kversion}-${version}.patch.xz";
      sha256 = "0423a2c2ed35b5df5983b517bf2a1a7495e67803a309479b8af613dd2a47da53";
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
          Enable musnix, a meta-module for realtime audio.
        '';
      };

      kernel.optimize = mkOption {
        type = types.bool;
        default = false;
        description = ''
          WARNING: Enabling this option will rebuild your kernel.

          If enabled, this option will configure the kernel to be
          preemptible, use the deadline I/O scheduler and High
          Precision Event Timer (HPET), and disable CPU frequency
          scaling.
        '';
      };

      kernel.realtime = mkOption {
        type = types.bool;
        default = false;
        description = ''
          WARNING: Enabling this option will rebuild your kernel.

          If enabled, this option will apply the realtime patch set
          to the kernel.
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
                            + optionalString cfg.kernel.optimize kernelConfigOptimize;
            };
          stdKernel =
            if cfg.kernel.optimize
              then pkgs.linux.override {
                extraConfig = "PREEMPT y\n"
                              + kernelConfigOptimize;
              }
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
