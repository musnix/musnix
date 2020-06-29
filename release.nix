let
  pkgs = import <nixpkgs> { overlays = [ (import ./overlay.nix) ]; };

  jobs = rec {
    musnixTest    = import ./tests/default.nix;
    linux_3_18_rt = pkgs.linux_3_18_rt;
    linux_4_1_rt  = pkgs.linux_4_1_rt;
    linux_4_4_rt  = pkgs.linux_4_4_rt;
    linux_4_9_rt  = pkgs.linux_4_9_rt;
    linux_4_11_rt = pkgs.linux_4_11_rt;
    linux_4_13_rt = pkgs.linux_4_13_rt;
    linux_4_14_rt = pkgs.linux_4_14_rt;
    linux_4_16_rt = pkgs.linux_4_16_rt;
    linux_4_18_rt = pkgs.linux_4_18_rt;
    linux_4_19_rt = pkgs.linux_4_19_rt;
    linux_5_0_rt  = pkgs.linux_5_0_rt;
    linux_5_4_rt  = pkgs.linux_5_4_rt;
    linux_5_6_rt  = pkgs.linux_5_6_rt;
    rtirq         = pkgs.rtirq;
  };
in
  jobs
