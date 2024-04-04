#
# To run:
#
#    nix flake check -L
#

(import ./lib.nix) {
  name = "musnix-boot";

  nodes.machine =
    { config, pkgs, ... }:
    { imports = [ ../default.nix ];

      musnix.enable = true;
      musnix.kernel.realtime = true;
      musnix.rtirq.enable = true;
      musnix.rtirq.highList = "timer";
      musnix.soundcardPciId = "00:05.0";
      musnix.rtcqs.enable = true;
    };

  testScript = builtins.readFile ./musnix-test.py;
}
