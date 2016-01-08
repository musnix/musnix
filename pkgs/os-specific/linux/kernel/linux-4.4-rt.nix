{ stdenv, fetchurl, perl, buildLinux, ... } @ args:

import <nixpkgs/pkgs/os-specific/linux/kernel/generic.nix> (args // rec {
  kversion = "4.4-rc6";
  pversion = "rt1";
  version = "${kversion}-${pversion}";
  modDirVersion = "4.4.0-rc6-rt1";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/testing/linux-${kversion}.tar.xz";
    sha256 = "1brb1v6185pf8gnff753hvpdsbdmjr5nsbvj0s4ljlpcgljrn6cb";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
