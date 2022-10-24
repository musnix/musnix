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

  cfg = (import <nixpkgs/nixos> { }).config.musnix or {
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
      SCHEDSTATS = lib.mkForce yes;
    } //
    lib.optionalAttrs enableOptimization {
      PREEMPT = yes;
    };

  realtimeConfig = { version, enableLatencytop, enableOptimization }:
    with (whenHelpers version);
    (standardConfig { inherit version enableLatencytop enableOptimization; }) // {
      EXPERT = yes; # PREEMPT_RT depends on it (in kernel/Kconfig.preempt).
      PREEMPT_RT = yes;
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

  linux_5_9_rt = callPackage ./pkgs/os-specific/linux/kernel/linux-5.9-rt.nix {
    kernelPatches = [
      super.kernelPatches.bridge_stp_helper
      self.realtimePatches.realtimePatch_5_9
    ];
  };

  linux_5_16_rt = callPackage ./pkgs/os-specific/linux/kernel/linux-5.16-rt.nix {
    kernelPatches = [
      super.kernelPatches.bridge_stp_helper
      self.realtimePatches.realtimePatch_5_16
    ];
  };

  linux_5_17_rt = callPackage ./pkgs/os-specific/linux/kernel/linux-5.17-rt.nix {
    kernelPatches = [
      super.kernelPatches.bridge_stp_helper
      self.realtimePatches.realtimePatch_5_17
    ];
  };

  linux_5_19_rt = callPackage ./pkgs/os-specific/linux/kernel/linux-5.19-rt.nix {
    kernelPatches = [
      super.kernelPatches.bridge_stp_helper
      self.realtimePatches.realtimePatch_5_19
    ];
  };

  linux_opt = super.linux.override {
    structuredExtraConfig = standardConfig { inherit (super.linux) version; };
  };

  linuxPackages_5_4_rt  = recurseIntoAttrs (linuxPackagesFor self.linux_5_4_rt);
  linuxPackages_5_6_rt  = recurseIntoAttrs (linuxPackagesFor self.linux_5_6_rt);
  linuxPackages_5_9_rt  = recurseIntoAttrs (linuxPackagesFor self.linux_5_9_rt);
  linuxPackages_5_16_rt = recurseIntoAttrs (linuxPackagesFor self.linux_5_16_rt);
  linuxPackages_5_17_rt = recurseIntoAttrs (linuxPackagesFor self.linux_5_17_rt);
  linuxPackages_5_19_rt = recurseIntoAttrs (linuxPackagesFor self.linux_5_19_rt);
  linuxPackages_opt     = recurseIntoAttrs (linuxPackagesFor self.linux_opt);

  linuxPackages_rt = self.linuxPackages_5_4_rt;
  linux_rt = self.linuxPackages_rt.kernel;

  linuxPackages_latest_rt = self.linuxPackages_5_19_rt;
  linux_latest_rt = self.linuxPackages_latest_rt.kernel;

  realtimePatches = callPackage ./pkgs/os-specific/linux/kernel/patches.nix {};

  rtirq = callPackage ./pkgs/os-specific/linux/rtirq {};

}
