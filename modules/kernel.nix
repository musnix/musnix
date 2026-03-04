{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let

  cfg = config.musnix;

in
{
  options.musnix = {
    kernel.realtime = mkOption {
      type = types.bool;
      default = false;
      description = ''
        NOTE: Enabling this option will rebuild your kernel.

        If enabled, this option will enable CONFIG_PREEMPT_RT on the kernel.

        For kernels 6.12 and later, PREEMPT_RT is available natively in the
        mainline kernel without additional patches. Set `musnix.kernel.packages`
        to any mainline kernel >= 6.12 (e.g. `pkgs.linuxPackages_6_12` or
        `pkgs.linuxPackages`) and musnix will automatically apply the required
        kernel configuration options without needing an RT-patched package.

        For kernels older than 6.12, set `musnix.kernel.packages` to one of
        the RT-patched packages provided by musnix (see that option's description).
      '';
    };
    kernel.packages = mkOption {
      default = pkgs.linuxPackages_rt;
      description = ''
        This option allows you to select the kernel used by musnix.

        For kernels 6.12 and later (recommended), use any mainline kernel
        package. musnix will automatically enable PREEMPT_RT via kernel
        configuration overrides — no patched package required:

          pkgs.linuxPackages         (default NixOS kernel, if >= 6.12)
          pkgs.linuxPackages_6_12
          pkgs.linuxPackages_6_13
          pkgs.linuxPackages_latest

        For kernels older than 6.12, use an RT-patched package provided
        by the musnix overlay:

          pkgs.linuxPackages_6_1_rt
          pkgs.linuxPackages_6_6_rt
          pkgs.linuxPackages_6_8_rt
          pkgs.linuxPackages_6_9_rt
          pkgs.linuxPackages_6_11_rt

        or the convenience aliases:

          pkgs.linuxPackages_rt        (currently pkgs.linuxPackages_6_6_rt)
          pkgs.linuxPackages_latest_rt (currently pkgs.linuxPackages_6_11_rt)
      '';
    };
  };

  config = mkIf cfg.kernel.realtime (
    let
      kernelVersion = cfg.kernel.packages.kernel.version;

      # PREEMPT_RT was merged into the mainline kernel in 6.12, so no external
      # patch is required for any kernel at or above that version.
      supportsNativeRT = versionAtLeast kernelVersion "6.12";

      # Kernel config overrides needed to enable native PREEMPT_RT.
      #
      # PREEMPT_RT requires EXPERT and conflicts with PREEMPT_VOLUNTARY,
      #
      # ignoreConfigErrors = true is still necessary because the exact set of
      # conflicting/disappearing symbols varies between kernel versions.  The
      # core RT options above are stable across all supported versions.
      nativeRTConfig = with lib.kernel; {
        EXPERT = yes;
        PREEMPT_RT = yes;
        RT_GROUP_SCHED = no;
        PREEMPT_VOLUNTARY = lib.mkForce no;
      };

      nativeRTPackages = pkgs.linuxPackagesFor (cfg.kernel.packages.kernel.override {
        structuredExtraConfig = nativeRTConfig;
        ignoreConfigErrors    = true;
      });
    in
    {
      boot.kernelPackages =
        if supportsNativeRT
        then nativeRTPackages
        else cfg.kernel.packages;
    }
  );
}
