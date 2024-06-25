{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.musnix = {
    das_watchdog.enable = mkOption {
      type = types.bool;
      default = config.musnix.kernel.realtime;
      description = ''
        If enabled, start the das_watchdog service.  This service will ensure
        that a realtime process won't hang the machine.
      '';
    };
  };

  config = {
    services.das_watchdog.enable = config.musnix.das_watchdog.enable;
  };
}
