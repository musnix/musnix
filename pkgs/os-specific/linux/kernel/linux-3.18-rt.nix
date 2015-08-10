{ stdenv, fetchurl, ... } @ args:

import <nixpkgs/pkgs/os-specific/linux/kernel/generic.nix> (args // rec {
  kversion = "3.18.18";
  pversion = "rt16";
  version = "${kversion}-${pversion}";
  extraMeta.branch = "3.18";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${kversion}.tar.xz";
    sha256 = "1fcd4xfnywwb3grdvcnf39njwzb40v10rnzagxqmancsaqy253jv";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
