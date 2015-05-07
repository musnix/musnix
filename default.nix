{ config, pkgs, ... }:

{ imports =
    [ ./modules/base.nix
      ./modules/kernel.nix
      ./modules/rtirq.nix
    ];
}
