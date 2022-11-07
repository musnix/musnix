{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.musnix;

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
      default = pkgs.linuxPackages_rt;
      description = ''
        This option allows you to select the real-time kernel used by musnix.

        Available packages:
        * pkgs.linuxPackages_5_4_rt
        * pkgs.linuxPackages_5_15_rt
        * pkgs.linuxPackages_6_0_rt
        or:
        * pkgs.linuxPackages_rt (currently pkgs.linuxPackages_5_15_rt)
        * pkgs.linuxPackages_latest_rt (currently pkgs.linuxPackages_6_0_rt)
      '';
    };
  };

  config = mkIf (cfg.kernel.latencytop || cfg.kernel.optimize || cfg.kernel.realtime) {

    boot.kernelPackages =
      if cfg.kernel.realtime
        then cfg.kernel.packages
        else pkgs.linuxPackages_opt;

  };
}
