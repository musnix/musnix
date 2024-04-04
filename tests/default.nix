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
    };

  testScript = ''
    machine.start()
    machine.wait_for_unit("default.target")
    result = machine.succeed("uname -v")
    print(result)
    if not "PREEMPT RT" or not "PREEMPT_RT" in result:
        raise Exception("Wrong OS")
    print("PASSED")
  '';
}
