{ stdenv, fetchurl, ... } @ args:

import <nixpkgs/pkgs/os-specific/linux/kernel/generic.nix> (args // rec {
  kversion = "3.14.53";
  pversion = "rt54";
  version = "${kversion}-${pversion}";
  extraMeta.branch = "3.14";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${kversion}.tar.xz";
    sha256 = "0zqaqa7gs895p521c82jggak9zlmiwmkfarh2ykvh423sxjbvs5i";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
