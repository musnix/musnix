{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.mixnix;

in

{
  options = {
    mixnix = {

      enable = mkOption {
        type = types.bool;
        default = false;
      };

      alsaSeq.enable = mkOption {
        type = types.bool;
        default = true;
      };

      ffado.enable = mkOption {
        type = types.bool;
        default = false;
      };

    };
  };

  config = mkIf (config.sound.enable && cfg.enable) {

    boot = {
      kernel.sysctl = { "vm.swappiness" = 10; };
      kernelModules =
        if cfg.alsaSeq.enable then
          [ "snd-seq"
            "snd-rawmidi"
          ]
        else [ ];
      kernelParams = [ "threadirq" ];
      postBootCommands = ''
        echo 2048 > /sys/class/rtc/rtc0/max_user_freq
        echo 2048 > /proc/sys/dev/hpet/max-user-freq
      '';
    };

    environment.systemPackages = with pkgs;
      if cfg.ffado.enable then
        [ pkgs.ffado ]
      else [ ];

    powerManagement.cpuFreqGovernor = "performance";

    security.pam.loginLimits = [
      { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
      { domain = "@audio"; item = "rtprio"; type = "-"; value = "99"; }
      { domain = "@audio"; item = "nofile"; type = "soft"; value = "99999"; }
      { domain = "@audio"; item = "nofile"; type = "hard"; value = "99999"; }
    ];

    services.udev = {
      packages =
        if cfg.ffado.enable then
          [ pkgs.ffado ]
        else [ ];

      extraRules = ''
        KERNEL=="rtc0", GROUP="audio"
        KERNEL=="hpet", GROUP="audio"
      '';
    };

    users.extraGroups= { audio = { }; };

  };
}
