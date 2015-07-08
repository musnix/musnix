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
      default = pkgs.linuxPackages_3_14_rt;
      description = ''
        FIXME: Kernel packages
      '';
    };
  };

  config = {
    boot.kernelPackages =
      if cfg.kernel.realtime
        then cfg.kernel.packages
        else pkgs.linuxPackages_opt;

    nixpkgs.config.packageOverrides = pkgs: with pkgs; rec {

      linux_opt       = pkgs.linux.override {
        extraConfig   = musnixStandardKernelExtraConfig;
      };

      linux_3_14_rt   = stdenv.lib.makeOverridable (import ../pkgs/os-specific/linux/kernel/linux-3.14-rt.nix) {
        inherit fetchurl stdenv perl buildLinux;
        kernelPatches = [ pkgs.kernelPatches.bridge_stp_helper
                          realtimePatches.realtimePatch_3_14
                        ];
        extraConfig   = musnixRealtimeKernelExtraConfig;
      };

      linuxPackages_3_14_rt = recurseIntoAttrs (linuxPackagesFor linux_3_14_rt linuxPackages_3_14_rt);
      linuxPackages_opt     = recurseIntoAttrs (linuxPackagesFor linux_opt     linuxPackages_opt);

      realtimePatches = callPackage ../pkgs/os-specific/linux/kernel/patches.nix { };

    };
  };
}
