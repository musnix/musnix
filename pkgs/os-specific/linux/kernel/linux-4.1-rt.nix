{ stdenv, fetchurl, ... } @ args:

import <nixpkgs/pkgs/os-specific/linux/kernel/generic.nix> (args // rec {
  kversion = "4.1.7";
  pversion = "rt8";
  version = "${kversion}-${pversion}";
  extraMeta.branch = "4.1";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${kversion}.tar.xz";
    sha256 = "0g1dnvak0pd03d4miy1025bw64wq71w29a058dzspdr6jcf9qwbn";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
