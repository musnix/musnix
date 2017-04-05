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
    DEFAULT_IOSCHED deadline
    HPET_TIMER y
    TREE_RCU_TRACE n
    RT_GROUP_SCHED? n
  '';

  kernelConfigRealtime = ''
    PREEMPT_RT_FULL y
    PREEMPT y
  '';

  musnixRealtimeKernelExtraConfig =
    kernelConfigRealtime
    + optionalString cfg.kernel.optimize kernelConfigOptimize
    + optionalString cfg.kernel.latencytop kernelConfigLatencyTOP;

  musnixStandardKernelExtraConfig =
    if cfg.kernel.optimize
      then "PREEMPT y\n"
           + kernelConfigOptimize
           + optionalString cfg.kernel.latencytop kernelConfigLatencyTOP
      else if cfg.kernel.latencytop
        then kernelConfigLatencyTOP
        else "";

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
    kernel.packages = mkOption {
      default = pkgs.linuxPackages_4_4_rt;
      description = ''
        This option allows you to select the real-time kernel used by musnix.

        Available packages:
        * pkgs.linuxPackages_3_14_rt
        * pkgs.linuxPackages_3_18_rt
        * pkgs.linuxPackages_4_1_rt
        * pkgs.linuxPackages_4_4_rt
        * pkgs.linuxPackages_4_6_rt
        * pkgs.linuxPackages_4_8_rt
        * pkgs.linuxPackages_4_9_rt
        or:
        * pkgs.linuxPackages_latest_rt (currently pkgs.linuxPackages_4_9_rt)
      '';
    };
  };

  config = mkIf (cfg.kernel.latencytop || cfg.kernel.optimize || cfg.kernel.realtime) {

    boot.kernelPackages =
      if cfg.kernel.realtime
        then cfg.kernel.packages
        else pkgs.linuxPackages_opt;

    nixpkgs.config.packageOverrides = pkgs: with pkgs; rec {

      linux_3_14_rt = callPackage ../pkgs/os-specific/linux/kernel/linux-3.14-rt.nix {
        kernelPatches = [ kernelPatches.bridge_stp_helper
                          realtimePatches.realtimePatch_3_14
                        ];
        extraConfig   = musnixRealtimeKernelExtraConfig;
      };

      linux_3_18_rt = callPackage ../pkgs/os-specific/linux/kernel/linux-3.18-rt.nix {
        kernelPatches = [ kernelPatches.bridge_stp_helper
                          realtimePatches.realtimePatch_3_18
                        ];
        extraConfig   = musnixRealtimeKernelExtraConfig;
      };

      linux_4_1_rt = callPackage ../pkgs/os-specific/linux/kernel/linux-4.1-rt.nix {
        kernelPatches = [ kernelPatches.bridge_stp_helper
                          realtimePatches.realtimePatch_4_1
                        ];
        extraConfig   = musnixRealtimeKernelExtraConfig;
      };

      linux_4_4_rt = callPackage ../pkgs/os-specific/linux/kernel/linux-4.4-rt.nix {
        kernelPatches = [ kernelPatches.bridge_stp_helper
                          realtimePatches.realtimePatch_4_4
                        ];
        extraConfig   = musnixRealtimeKernelExtraConfig;
      };

      linux_4_6_rt = callPackage ../pkgs/os-specific/linux/kernel/linux-4.6-rt.nix {
        kernelPatches = [ kernelPatches.bridge_stp_helper
                          realtimePatches.realtimePatch_4_6
                        ];
        extraConfig   = musnixRealtimeKernelExtraConfig;
      };

      linux_4_8_rt = callPackage ../pkgs/os-specific/linux/kernel/linux-4.8-rt.nix {
        kernelPatches = [ kernelPatches.bridge_stp_helper
                          kernelPatches.modinst_arg_list_too_long
                          realtimePatches.realtimePatch_4_8
                        ];
        extraConfig   = musnixRealtimeKernelExtraConfig;
      };

      linux_4_9_rt = callPackage ../pkgs/os-specific/linux/kernel/linux-4.9-rt.nix {
        kernelPatches = [ kernelPatches.bridge_stp_helper
                          kernelPatches.modinst_arg_list_too_long
                          realtimePatches.realtimePatch_4_9
                        ];
        extraConfig   = musnixRealtimeKernelExtraConfig;
      };

      linux_opt = linux.override {
        extraConfig = musnixStandardKernelExtraConfig;
      };

      linuxPackages_3_14_rt = recurseIntoAttrs (linuxPackagesFor linux_3_14_rt);
      linuxPackages_3_18_rt = recurseIntoAttrs (linuxPackagesFor linux_3_18_rt);
      linuxPackages_4_1_rt  = recurseIntoAttrs (linuxPackagesFor linux_4_1_rt);
      linuxPackages_4_4_rt  = recurseIntoAttrs (linuxPackagesFor linux_4_4_rt);
      linuxPackages_4_6_rt  = recurseIntoAttrs (linuxPackagesFor linux_4_6_rt);
      linuxPackages_4_8_rt  = recurseIntoAttrs (linuxPackagesFor linux_4_8_rt);
      linuxPackages_4_9_rt  = recurseIntoAttrs (linuxPackagesFor linux_4_9_rt);
      linuxPackages_opt     = recurseIntoAttrs (linuxPackagesFor linux_opt);

      linuxPackages_latest_rt = linuxPackages_4_9_rt;

      realtimePatches = callPackage ../pkgs/os-specific/linux/kernel/patches.nix { };
    };
  };
}
