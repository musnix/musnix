{
  description = "Real-time audio in NixOS";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs = { self, nixpkgs }: let
      forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" ];
    in {
      nixosModules.musnix = import ./default.nix;
      nixosModules.default = self.nixosModules.musnix;
      checks = forAllSystems (system: let
        checkArgs = {
          pkgs = nixpkgs.legacyPackages.${system};
          inherit self;
        };
      in {
        default = import ./tests/default.nix checkArgs;
      });
      packages = forAllSystems (platform: {
        rtcqs = nixpkgs.legacyPackages.${platform}.callPackage ./pkgs/rtcqs.nix {};
      });
  };
}
