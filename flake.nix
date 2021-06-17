{
    description = "Real-time audio in NixOS";
    inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    outputs = { self, nixpkgs }: {
        nixosModules.musnix = import ./default.nix;
        nixosModule = self.nixosModules.musnix;
    };
}