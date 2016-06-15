{ stdenv, fetchurl, perl, buildLinux, ... } @ args:

import <nixpkgs/pkgs/os-specific/linux/kernel/generic.nix> (args // rec {
  kversion = "4.6.2";
  pversion = "rt5";
  version = "${kversion}-${pversion}";
  extraMeta.branch = "4.6";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${kversion}.tar.xz";
    sha256 = "0shwmc5kk8yf2mk5chhikq5hspmh32z4s68gip12wz58kp3g6n71";
  };

  kernelPatches = args.kernelPatches;

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
