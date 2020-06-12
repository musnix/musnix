import <nixpkgs/nixos/tests/make-test-python.nix> {
  machine =
    { config, pkgs, ... }:
    { imports = [ ../default.nix ];

      musnix.enable = true;
      musnix.kernel.optimize = true;
      musnix.kernel.realtime = true;
      musnix.kernel.packages = pkgs.linuxPackages_latest_rt;
      musnix.rtirq.enable = true;
      musnix.rtirq.highList = "timer";
      musnix.soundcardPciId = "00:05.0";
    };

  testScript = ''
    machine.start()
    machine.wait_for_unit("default.target")
    print(machine.succeed("uname -v"))
    if not "PREEMPT" in machine.succeed("uname -v"):
        raise Exception("Wrong OS")
  '';
}
