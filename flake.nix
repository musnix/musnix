{
    description = "Real-time audio in NixOS";
    inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    outputs = { self, nixpkgs }: let
        systems = [
            "x86_64-linux"
            "aarch64-linux"
        ];
        forAllSystems = import ./default.nix { pkgs = final; };
    in {
        nixosModules.rtirq = forAllSystems (system: import ./default.nix {
            inherit system;
        });
        nixosModule = self.nixosModules.musnix;
    };
}