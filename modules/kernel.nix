{ config, lib, pkgs, ... }:

with lib.kernel;
with lib;

let

  cfg = config.musnix;

  standardConfig = version: with (lib.kernel.whenHelpers version);
    optionalAttrs cfg.kernel.latencytop {
      LATENCYTOP = yes;
      SCHEDSTATS = yes;
    } //
    optionalAttrs cfg.kernel.optimize {
      PREEMPT = yes;
      # DEADLINE was renamed to MT_DEADLINE and enabled by default.
      IOSCHED_DEADLINE = whenOlder "5" yes;
      DEFAULT_DEADLINE = whenOlder "5" yes;
      DEFAULT_IOSCHED = whenOlder "5" (freeform "deadline");
    };

  realtimeConfig = version:
    (standardConfig version) // {
      PREEMPT = yes;
      PREEMPT_RT_FULL = yes;
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
        preemptible and use the deadline I/O scheduler.
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
      default = pkgs.linuxPackages_5_4_rt;
      description = ''
        This option allows you to select the real-time kernel used by musnix.

        Available packages:
        * pkgs.linuxPackages_3_18_rt
        * pkgs.linuxPackages_4_1_rt
        * pkgs.linuxPackages_4_4_rt
        * pkgs.linuxPackages_4_9_rt
        * pkgs.linuxPackages_4_11_rt
        * pkgs.linuxPackages_4_13_rt
        * pkgs.linuxPackages_4_14_rt
        * pkgs.linuxPackages_4_16_rt
        * pkgs.linuxPackages_4_18_rt
        * pkgs.linuxPackages_4_19_rt
        * pkgs.linuxPackages_5_0_rt
        * pkgs.linuxPackages_5_4_rt
        or:
        * pkgs.linuxPackages_latest_rt (currently pkgs.linuxPackages_5_0_rt)
      '';
    };
  };

  config = mkIf (cfg.kernel.latencytop || cfg.kernel.optimize || cfg.kernel.realtime) {

    boot.kernelPackages =
      if cfg.kernel.realtime
        then cfg.kernel.packages
        else pkgs.linuxPackages_opt;

    nixpkgs.config.packageOverrides = pkgs: with pkgs; rec {

      linux_3_18_rt = callPackage ../pkgs/os-specific/linux/kernel/linux-3.18-rt.nix {
        kernelPatches = [ kernelPatches.bridge_stp_helper
                          realtimePatches.realtimePatch_3_18
                        ];
        structuredExtraConfig = realtimeConfig "3.18";
      };

      linux_4_1_rt = callPackage ../pkgs/os-specific/linux/kernel/linux-4.1-rt.nix {
        kernelPatches = [ kernelPatches.bridge_stp_helper
                          realtimePatches.realtimePatch_4_1
                        ];
        structuredExtraConfig = realtimeConfig "4.1";
      };

      linux_4_4_rt = callPackage ../pkgs/os-specific/linux/kernel/linux-4.4-rt.nix {
        kernelPatches = [ kernelPatches.bridge_stp_helper
                          realtimePatches.realtimePatch_4_4
                        ];
        structuredExtraConfig = realtimeConfig "4.4";
      };

      linux_4_9_rt = callPackage ../pkgs/os-specific/linux/kernel/linux-4.9-rt.nix {
        kernelPatches = [ kernelPatches.bridge_stp_helper
                          kernelPatches.modinst_arg_list_too_long
                          realtimePatches.realtimePatch_4_9
                        ];
        structuredExtraConfig = realtimeConfig "4.9";
      };

      linux_4_11_rt = callPackage ../pkgs/os-specific/linux/kernel/linux-4.11-rt.nix {
        kernelPatches = [ kernelPatches.bridge_stp_helper
                          kernelPatches.modinst_arg_list_too_long
                          realtimePatches.realtimePatch_4_11
                        ];
        structuredExtraConfig = realtimeConfig "4.11";
      };

      linux_4_13_rt = callPackage ../pkgs/os-specific/linux/kernel/linux-4.13-rt.nix {
        kernelPatches = [ kernelPatches.bridge_stp_helper
                          kernelPatches.modinst_arg_list_too_long
                          realtimePatches.realtimePatch_4_13
                        ];
        structuredExtraConfig = realtimeConfig "4.13";
      };

      linux_4_14_rt = callPackage ../pkgs/os-specific/linux/kernel/linux-4.14-rt.nix {
        kernelPatches = [ kernelPatches.bridge_stp_helper
                          kernelPatches.modinst_arg_list_too_long
                          realtimePatches.realtimePatch_4_14
                        ];
        structuredExtraConfig = realtimeConfig "4.14";
      };

      linux_4_16_rt = callPackage ../pkgs/os-specific/linux/kernel/linux-4.16-rt.nix {
        kernelPatches = [ kernelPatches.bridge_stp_helper
                          kernelPatches.modinst_arg_list_too_long
                          realtimePatches.realtimePatch_4_16
                        ];
        structuredExtraConfig = realtimeConfig "4.16";
      };
      linux_4_18_rt = callPackage ../pkgs/os-specific/linux/kernel/linux-4.18-rt.nix {
        kernelPatches = [ kernelPatches.bridge_stp_helper
                          kernelPatches.modinst_arg_list_too_long
                          realtimePatches.realtimePatch_4_18
                        ];
        structuredExtraConfig = realtimeConfig "4.18";
      };
      linux_4_19_rt = callPackage ../pkgs/os-specific/linux/kernel/linux-4.19-rt.nix {
        kernelPatches = [ kernelPatches.bridge_stp_helper
                          kernelPatches.modinst_arg_list_too_long
                          realtimePatches.realtimePatch_4_19
                        ];
        structuredExtraConfig = realtimeConfig "4.19";
      };
      linux_5_0_rt = callPackage ../pkgs/os-specific/linux/kernel/linux-5.0-rt.nix {
        kernelPatches = [ kernelPatches.bridge_stp_helper
                          kernelPatches.modinst_arg_list_too_long
                          realtimePatches.realtimePatch_5_0
                        ];
        structuredExtraConfig = realtimeConfig "5.0";
      };
      linux_5_4_rt = callPackage ../pkgs/os-specific/linux/kernel/linux-5.4-rt.nix {
        kernelPatches = [ kernelPatches.bridge_stp_helper
                          realtimePatches.realtimePatch_5_4
                        ];
        structuredExtraConfig = realtimeConfig "5.4";
      };



      linux_opt = linux.override {
        structuredExtraConfig = standardConfig linux.version;
      };

      linuxPackages_3_18_rt = recurseIntoAttrs (linuxPackagesFor linux_3_18_rt);
      linuxPackages_4_1_rt  = recurseIntoAttrs (linuxPackagesFor linux_4_1_rt);
      linuxPackages_4_4_rt  = recurseIntoAttrs (linuxPackagesFor linux_4_4_rt);
      linuxPackages_4_9_rt  = recurseIntoAttrs (linuxPackagesFor linux_4_9_rt);
      linuxPackages_4_11_rt = recurseIntoAttrs (linuxPackagesFor linux_4_11_rt);
      linuxPackages_4_13_rt = recurseIntoAttrs (linuxPackagesFor linux_4_13_rt);
      linuxPackages_4_14_rt = recurseIntoAttrs (linuxPackagesFor linux_4_14_rt);
      linuxPackages_4_16_rt = recurseIntoAttrs (linuxPackagesFor linux_4_16_rt);
      linuxPackages_4_18_rt = recurseIntoAttrs (linuxPackagesFor linux_4_18_rt);
      linuxPackages_4_19_rt = recurseIntoAttrs (linuxPackagesFor linux_4_19_rt);
      linuxPackages_5_0_rt  = recurseIntoAttrs (linuxPackagesFor linux_5_0_rt);
      linuxPackages_5_4_rt  = recurseIntoAttrs (linuxPackagesFor linux_5_4_rt);
      linuxPackages_opt     = recurseIntoAttrs (linuxPackagesFor linux_opt);

      linuxPackages_latest_rt = linuxPackages_5_0_rt;

      realtimePatches = callPackage ../pkgs/os-specific/linux/kernel/patches.nix { };
    };
  };
}
