{ stdenv, fetchurl, perl, buildLinux, ... } @ args:

import <nixpkgs/pkgs/os-specific/linux/kernel/generic.nix> (args // rec {
  kversion = "4.4.15";
  pversion = "rt23";
  version = "${kversion}-${pversion}";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${kversion}.tar.xz";
    sha256 = "1c5ccki68s5207ccg07h8pplcsz2kgsnkbpsvdpq0f8g3xqk8dih";
  };

  kernelPatches = args.kernelPatches;

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
