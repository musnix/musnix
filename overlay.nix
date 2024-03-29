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

  realtimeConfig = { version }:
    with (whenHelpers version);
    {
      EXPERT = yes; # PREEMPT_RT depends on it (in kernel/Kconfig.preempt).
      PREEMPT_RT = yes;
      PREEMPT_VOLUNTARY = lib.mkForce no; # PREEMPT_RT deselects it.
      RT_GROUP_SCHED = lib.mkForce (option no); # Removed by sched-disable-rt-group-sched-on-rt.patch.
    };

in
with lib;
{

  buildLinuxRT = { ... }@args:
    super.buildLinux (args // {
      structuredExtraConfig = realtimeConfig { version = args.extraMeta.branch; };
    } // (args.argsOverride or {}));

  linux_6_1_rt = callPackage ./pkgs/os-specific/linux/kernel/linux-6.1-rt.nix {
    kernelPatches = [
      super.kernelPatches.bridge_stp_helper
      super.kernelPatches.export-rt-sched-migrate
      self.realtimePatches.realtimePatch_6_1
    ];
  };

  linux_6_6_rt = callPackage ./pkgs/os-specific/linux/kernel/linux-6.6-rt.nix {
    kernelPatches = [
      super.kernelPatches.bridge_stp_helper
      super.kernelPatches.export-rt-sched-migrate
      self.realtimePatches.realtimePatch_6_6
    ];
  };

  linux_6_8_rt = callPackage ./pkgs/os-specific/linux/kernel/linux-6.8-rt.nix {
    kernelPatches = [
      super.kernelPatches.bridge_stp_helper
      super.kernelPatches.export-rt-sched-migrate
      self.realtimePatches.realtimePatch_6_8
    ];
  };

  linuxPackages_6_1_rt  = recurseIntoAttrs (linuxPackagesFor self.linux_6_1_rt);
  linuxPackages_6_6_rt  = recurseIntoAttrs (linuxPackagesFor self.linux_6_6_rt);
  linuxPackages_6_8_rt  = recurseIntoAttrs (linuxPackagesFor self.linux_6_8_rt);

  linuxPackages_rt = self.linuxPackages_6_6_rt;
  linux_rt = self.linuxPackages_rt.kernel;

  linuxPackages_latest_rt = self.linuxPackages_6_8_rt;
  linux_latest_rt = self.linuxPackages_latest_rt.kernel;

  realtimePatches = callPackage ./pkgs/os-specific/linux/kernel/patches.nix {};

  rtirq = callPackage ./pkgs/os-specific/linux/rtirq {};

}
