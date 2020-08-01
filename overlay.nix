self: super:

let

  inherit (super) lib callPackage linuxPackagesFor recurseIntoAttrs;

  # Since 20.09 this is a part of lib.kernel
  option = x:
      x // { optional = true; };

  yes      = { tristate    = "y"; optional = false; };
  no       = { tristate    = "n"; optional = false; };
  module   = { tristate    = "m"; optional = false; };
  freeform = x: { freeform = x; optional = false; };

  whenHelpers = version: with lib; {
    whenAtLeast = ver: mkIf (versionAtLeast version ver);
    whenOlder   = ver: mkIf (versionOlder version ver);
    # range is (inclusive, exclusive)
    whenBetween = verLow: verHigh: mkIf (versionAtLeast version verLow && versionOlder version verHigh);
  };

  cfg = super.config.musnix or {
    kernel.latencytop = false;
    kernel.optimize = false;
  };

  standardConfig = {
    version,
    enableLatencytop ? cfg.kernel.latencytop,
    enableOptimization ? cfg.kernel.optimize
  }:

    with (whenHelpers version);
    lib.optionalAttrs enableLatencytop {
      LATENCYTOP = yes;
      SCHEDSTATS = yes;
    } //
    lib.optionalAttrs enableOptimization {
      PREEMPT = yes;
      # DEADLINE was renamed to MT_DEADLINE and enabled by default.
      IOSCHED_DEADLINE = whenOlder "5" yes;
      DEFAULT_DEADLINE = whenOlder "5" yes;
      DEFAULT_IOSCHED = whenOlder "5" (freeform "deadline");
    };

  realtimeConfig = { version, enableLatencytop, enableOptimization }:
    with (whenHelpers version);
    (standardConfig { inherit version enableLatencytop enableOptimization; }) // {
      PREEMPT = whenOlder "5.4" yes; # PREEMPT_RT deselects it.
      PREEMPT_RT_FULL = whenOlder "5.4" yes; # Renamed to PREEMPT_RT when merged into the mainline.
      EXPERT = whenAtLeast "5.4" yes; # PREEMPT_RT depends on it (in kernel/Kconfig.preempt).
      PREEMPT_RT = whenAtLeast "5.4" yes;
      PREEMPT_VOLUNTARY = lib.mkForce no; # PREEMPT_RT deselects it.
      RT_GROUP_SCHED = lib.mkForce (option no); # Removed by sched-disable-rt-group-sched-on-rt.patch.
    };

in
with lib;
{

  buildLinuxRT = {
    enableLatencytop ? cfg.kernel.latencytop,
    enableOptimization ? cfg.kernel.optimize,
    ...
  }@args: super.buildLinux (args // {
    structuredExtraConfig = realtimeConfig {
      inherit enableLatencytop enableOptimization;
      version = args.extraMeta.branch;
    };
  } // (args.argsOverride or {}));

  linux_4_4_rt = callPackage ./pkgs/os-specific/linux/kernel/linux-4.4-rt.nix {
    kernelPatches = [
      super.kernelPatches.bridge_stp_helper
      self.realtimePatches.realtimePatch_4_4
    ];
  };

  linux_4_9_rt = callPackage ./pkgs/os-specific/linux/kernel/linux-4.9-rt.nix {
    kernelPatches = [
      super.kernelPatches.bridge_stp_helper
      super.kernelPatches.modinst_arg_list_too_long
      self.realtimePatches.realtimePatch_4_9
    ];
  };

  linux_4_14_rt = callPackage ./pkgs/os-specific/linux/kernel/linux-4.14-rt.nix {
    kernelPatches = [
      super.kernelPatches.bridge_stp_helper
      super.kernelPatches.modinst_arg_list_too_long
      self.realtimePatches.realtimePatch_4_14
    ];
  };

  linux_4_18_rt = callPackage ./pkgs/os-specific/linux/kernel/linux-4.18-rt.nix {
    kernelPatches = [
      super.kernelPatches.bridge_stp_helper
      super.kernelPatches.modinst_arg_list_too_long
      self.realtimePatches.realtimePatch_4_18
    ];
  };

  linux_4_19_rt = callPackage ./pkgs/os-specific/linux/kernel/linux-4.19-rt.nix {
    kernelPatches = [
      super.kernelPatches.bridge_stp_helper
      super.kernelPatches.modinst_arg_list_too_long
      self.realtimePatches.realtimePatch_4_19
    ];
  };

  linux_5_0_rt = callPackage ./pkgs/os-specific/linux/kernel/linux-5.0-rt.nix {
    kernelPatches = [
      super.kernelPatches.bridge_stp_helper
      super.kernelPatches.modinst_arg_list_too_long
      self.realtimePatches.realtimePatch_5_0
    ];
  };

  linux_5_4_rt = callPackage ./pkgs/os-specific/linux/kernel/linux-5.4-rt.nix {
    kernelPatches = [
      super.kernelPatches.bridge_stp_helper
      self.realtimePatches.realtimePatch_5_4
    ];
  };

  linux_5_6_rt = callPackage ./pkgs/os-specific/linux/kernel/linux-5.6-rt.nix {
    kernelPatches = [
      super.kernelPatches.bridge_stp_helper
      self.realtimePatches.realtimePatch_5_6
    ];
  };

  linux_opt = super.linux.override {
    structuredExtraConfig = standardConfig { inherit (super.linux) version; };
  };

  linuxPackages_4_4_rt  = recurseIntoAttrs (linuxPackagesFor self.linux_4_4_rt);
  linuxPackages_4_9_rt  = recurseIntoAttrs (linuxPackagesFor self.linux_4_9_rt);
  linuxPackages_4_14_rt = recurseIntoAttrs (linuxPackagesFor self.linux_4_14_rt);
  linuxPackages_4_18_rt = recurseIntoAttrs (linuxPackagesFor self.linux_4_18_rt);
  linuxPackages_4_19_rt = recurseIntoAttrs (linuxPackagesFor self.linux_4_19_rt);
  linuxPackages_5_0_rt  = recurseIntoAttrs (linuxPackagesFor self.linux_5_0_rt);
  linuxPackages_5_4_rt  = recurseIntoAttrs (linuxPackagesFor self.linux_5_4_rt);
  linuxPackages_5_6_rt  = recurseIntoAttrs (linuxPackagesFor self.linux_5_6_rt);
  linuxPackages_opt     = recurseIntoAttrs (linuxPackagesFor self.linux_opt);

  linuxPackages_rt = self.linuxPackages_5_4_rt;
  linux_rt = self.linuxPackages_rt.kernel;

  linuxPackages_latest_rt = self.linuxPackages_5_6_rt;
  linux_latest_rt = self.linuxPackages_latest_rt.kernel;

  realtimePatches = callPackage ./pkgs/os-specific/linux/kernel/patches.nix {};

  rtirq = callPackage ./pkgs/os-specific/linux/rtirq {};

}
