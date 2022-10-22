let
  pkgs = import <nixpkgs> { overlays = [ (import ./overlay.nix) ]; };

  jobs = rec {
    musnixTest    = import ./tests/default.nix;
    linux_5_4_rt  = pkgs.linux_5_4_rt;
    linux_5_6_rt  = pkgs.linux_5_6_rt;
    linux_5_9_rt  = pkgs.linux_5_9_rt;
    linux_5_16_rt = pkgs.linux_5_16_rt;
    linux_5_17_rt = pkgs.linux_5_17_rt;
    linux_5_19_rt = pkgs.linux_5_19_rt;
    rtirq         = pkgs.rtirq;
  };
in
  jobs
