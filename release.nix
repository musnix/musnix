let
  pkgs = import <nixpkgs> { overlays = [ (import ./overlay.nix) ]; };

  jobs = rec {
    linux_6_1_rt = pkgs.linux_6_1_rt;
    linux_6_6_rt = pkgs.linux_6_6_rt;
    linux_6_8_rt = pkgs.linux_6_8_rt;
    linux_rt = pkgs.linux_rt;
    linux_latest_rt = pkgs.linux_latest_rt;
    rtirq = pkgs.rtirq;
  };
in
jobs
