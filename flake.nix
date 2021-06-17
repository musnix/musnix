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
        nixosModules.musnix = import ./default.nix;
        nixosModule = self.nixosModules.musnix;
    };
}