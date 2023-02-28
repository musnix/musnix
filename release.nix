let
  pkgs = import <nixpkgs> { overlays = [ (import ./overlay.nix) ]; };

  jobs = rec {
    musnixTest      = import ./tests/default.nix;
    linux_5_15_rt   = pkgs.linux_5_15_rt;
    linux_6_1_rt    = pkgs.linux_6_1_rt;
    linux_6_2_rt    = pkgs.linux_6_2_rt;
    linux_rt        = pkgs.linux_rt;
    linux_latest_rt = pkgs.linux_latest_rt;
    rtirq           = pkgs.rtirq;
  };
in
  jobs
