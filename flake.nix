{
    description = "Real-time audio in NixOS";
    inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    outputs = { self, nixpkgs }: let
        systems = [
            "x86_64-linux"
            "aarch64-linux"
        ];
        forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
    in {
        nixosModules.rtirq = forAllSystems (system: import ./default.nix {
            inherit system;
        });
        nixosModules.musnix = import ./default.nix;
        nixosModule = self.nixosModules.musnix;
    };
}