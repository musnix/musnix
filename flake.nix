{
  description = "Real-time audio in NixOS";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs =
    { self, nixpkgs }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" ];
    in
    {
      nixosModules.musnix = import ./default.nix;
      nixosModules.default = self.nixosModules.musnix;
      checks = forAllSystems (
        system:
        let
          checkArgs = {
            pkgs = nixpkgs.legacyPackages.${system};
            inherit self;
          };
        in
        {
          default = import ./tests/default.nix checkArgs;
        }
      );
      packages = forAllSystems (platform: {
        rtcqs = nixpkgs.legacyPackages.${platform}.callPackage ./pkgs/rtcqs.nix { };

        # Pinned in Cachix by CI so the check result and its expensive build
        # inputs (notably the realtime kernel) survive garbage collection.
        cachix-pin =
          let
            check = self.checks.${platform}.default;
          in
          nixpkgs.legacyPackages.${platform}.linkFarm "musnix-cachix-pin" [
            {
              name = "check";
              path = check;
            }
            {
              name = "driver";
              path = check.driver;
            }
            {
              name = "kernel";
              path = check.nodes.machine.boot.kernelPackages.kernel;
            }
          ];
      });
    };
}
