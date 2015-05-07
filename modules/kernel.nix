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

  kernelSources = rec {
    version = "3.14.36";
    src = pkgs.fetchurl {
      url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
      sha256 = "03pl303z3vvldc3hamlrq77mcy66nsqdfk7yi43nzyrnmrby3l0r";
    };
  };

  realtimePatch = rec {
    version = "rt34";
    kversion = "3.14.36";
    name = "rt-${kversion}-${version}";
    patch = pkgs.fetchurl {
      url = "https://www.kernel.org/pub/linux/kernel/projects/rt/3.14/older/patch-${kversion}-${version}.patch.xz";
      sha256 = "098nnnbh989rci2x2zmsjdj5h6ivgz4yp3qa30494rbay6v8faiv";
    };
  };

in {
  options.musnix = {
    kernel.latencytop = mkOption {
      type = types.bool;
      default = false;
      description = ''
        NOTE: Enabling this option will rebuild your kernel.

        NOTE: This option is only intended to be used for diagnostic purposes,
        and may cause other issues.

        If enabled, this option will configure the kernel to use a
        latency tracking infrastructure that is used by the
        "latencytop" userspace tool.
      '';
    };
    kernel.optimize = mkOption {
      type = types.bool;
      default = false;
      description = ''
        NOTE: Enabling this option will rebuild your kernel.

        If enabled, this option will configure the kernel to be
        preemptible, to use the deadline I/O scheduler, and to use
        the High Precision Event Timer (HPET).
      '';
    };
    kernel.realtime = mkOption {
      type = types.bool;
      default = false;
      description = ''
        NOTE: Enabling this option will rebuild your kernel.

        If enabled, this option will apply the CONFIG_PREEMPT_RT
        patch to the kernel.
      '';
    };
  };

  config = {
    boot.kernelPackages =
      let
        rtKernel =
          pkgs.linux_3_14.override {
            argsOverride = kernelSources;
            kernelPatches = [ realtimePatch ];
            extraConfig = kernelConfigRealtime
                          + optionalString cfg.kernel.optimize kernelConfigOptimize
                          + optionalString cfg.kernel.latencytop kernelConfigLatencyTOP;
          };
        stdKernel =
          if cfg.kernel.optimize
            then pkgs.linux.override {
              extraConfig = "PREEMPT y\n"
                            + kernelConfigOptimize
                            + optionalString cfg.kernel.latencytop kernelConfigLatencyTOP;
            }
            else if cfg.kernel.latencytop
              then pkgs.linux.override { extraConfig = kernelConfigLatencyTOP; }
              else pkgs.linux;
        musnixKernel =
          if cfg.kernel.realtime then rtKernel else stdKernel;
        musnixKernelPackages =
          pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor musnixKernel musnixKernelPackages);
      in musnixKernelPackages;
  };
}
