{ config, pkgs, ... }:

{ imports =
    [ ./modules/base.nix
      ./modules/kernel.nix
      ./modules/other.nix
      ./modules/rtirq.nix
    ];

  nixpkgs.overlays = [
    (import ./overlay.nix)
  ];
}
