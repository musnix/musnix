{ stdenv, fetchurl, hostPlatform, perl, buildLinux, ... } @ args:

import <nixpkgs/pkgs/os-specific/linux/kernel/generic.nix> (args // rec {
  kversion = "4.11.9";
  pversion = "rt7";
  version = "${kversion}-${pversion}";
  extraMeta.branch = "4.11";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${kversion}.tar.xz";
    sha256 = "0q60690hmqhz2x3v6qyjq7lhp2j99dcldvd46myc9ggp78d93j1z";
  };

  kernelPatches = args.kernelPatches;

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
