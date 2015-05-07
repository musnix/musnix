{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.musnix.rtirq;

  rtirq = pkgs.callPackage ../pkgs/rtirq/default.nix { };

  rtirqConf = pkgs.writeText "rtirq.conf" ''
    # This is a generated file.  Do not edit!
    RTIRQ_NAME_LIST="${cfg.nameList}"
    RTIRQ_PRIO_HIGH=${toString cfg.prioHigh}
    RTIRQ_PRIO_DECR=${toString cfg.prioDecr}
    RTIRQ_PRIO_LOW=${toString cfg.prioLow}
    RTIRQ_RESET_ALL=${toString cfg.resetAll}
    RTIRQ_NON_THREADED="${cfg.nonThreaded}"
    ${optionalString (cfg.highList != "") ''RTIRQ_HIGH_LIST="${cfg.highList}"''}
  '';

in {
  options.musnix.rtirq = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable rtirq
      '';
    };
    nameList = mkOption {
      type = types.str;
      default = "snd usb i8042";
      description = ''
        IRQ thread service names
      '';
    };
    prioHigh = mkOption {
      type = types.int;
      default = 90;
      description = ''
        Highest priority
      '';
    };
    prioDecr = mkOption {
      type = types.int;
      default = 5;
      description = ''
        Priority decrease step
      '';
    };
    prioLow = mkOption {
      type = types.int;
      default = 51;
      description = ''
        Lowest priority
      '';
    };
    resetAll = mkOption {
      type = types.int;
      default = 0;
      description = ''
        Whether to reset all IRQ threads to SCHED_OTHER
      '';
    };
    nonThreaded = mkOption {
      type = types.str;
      default = "rtc snd";
      description = ''
        Which services should be NOT threaded
      '';
    };
    highList = mkOption {
      type = types.str;
      default = "";
      description = ''
        Process names which will be forced to the
        highest realtime priority range (99-91)
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ rtirq ];
    environment.etc =
      [ { source = rtirqConf;
          target = "rtirq.conf";
        }
      ];
    systemd.services.rtirq = {
      description = "IRQ thread tuning for realtime kernels";
      after = [ "multi-user.target" "sound.target" ];
      wantedBy = [ "multi-user.target" ];
      path = with pkgs; [
        gawk
        gnugrep
        gnused
        procps
      ];
      serviceConfig = {
        User = "root";
        Type = "oneshot";
        ExecStart = "${rtirq}/bin/rtirq start";
        ExecStop = "${rtirq}/bin/rtirq stop";
        RemainAfterExit = true;
      };
    };
  };
}
