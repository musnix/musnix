# see https://blog.thalheim.io/2023/01/08/how-to-use-nixos-testing-framework-with-flakes/

# The first argument to this function is the test module itself
test:

# These arguments are provided by `flake.nix` on import, see checkArgs
{ pkgs, self}:

let
  inherit (pkgs) lib;

  # this imports the nixos library that contains our testing framework
  nixos-lib = import (pkgs.path + "/nixos/lib") {};
in
(nixos-lib.runTest {
  hostPkgs = pkgs;

  # This speeds up the evaluation by skipping evaluating documentation
  # (optional)
  defaults.documentation.enable = lib.mkDefault false;

  # This makes `self` available in the NixOS configuration of our virtual
  # machines. This is useful for referencing modules or packages from your own
  # flake as well as importing from other flakes.
  node.specialArgs = { inherit self; };

  imports = [ test ];
}).config.result

