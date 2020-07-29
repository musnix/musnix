let
  pkgs = import <nixpkgs> { overlays = [ (import ./overlay.nix) ]; };

  jobs = rec {
    musnixTest    = import ./tests/default.nix;
    linux_4_4_rt  = pkgs.linux_4_4_rt;
    linux_4_9_rt  = pkgs.linux_4_9_rt;
    linux_4_14_rt = pkgs.linux_4_14_rt;
    linux_4_18_rt = pkgs.linux_4_18_rt;
    linux_4_19_rt = pkgs.linux_4_19_rt;
    linux_5_0_rt  = pkgs.linux_5_0_rt;
    linux_5_4_rt  = pkgs.linux_5_4_rt;
    linux_5_6_rt  = pkgs.linux_5_6_rt;
    rtirq         = pkgs.rtirq;
  };
in
  jobs
