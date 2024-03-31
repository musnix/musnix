#
# To run:
#
#    nix-build tests/default.nix
#

import <nixpkgs/nixos/tests/make-test-python.nix> {
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

  testScript = ''
    machine.start()
    machine.wait_for_unit("multi-user.target")
    result = machine.succeed("uname -v")
    print(result)
    if not "PREEMPT RT" or not "PREEMPT_RT" in result:
        raise Exception("Wrong OS")
    with subtest("rtcqs"):
        machine.succeed("useradd -m musnix")
        machine.succeed("usermod -a -G audio musnix")
        result = machine.succeed("su - musnix -c rtcqs")
        print(result)
        if not "rtcqs - version" in result:
            raise ValueError("rtcqs not installed")
    print("PASSED")
  '';
}
