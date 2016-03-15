{ stdenv, fetchurl, perl, buildLinux, ... } @ args:

import <nixpkgs/pkgs/os-specific/linux/kernel/generic.nix> (args // rec {
  kversion = "3.18.28";
  pversion = "rt28";
  version = "${kversion}-${pversion}";
  extraMeta.branch = "3.18";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${kversion}.tar.xz";
    sha256 = "1vd7xm5wh082bwh93f69r99727y1yd5l6qjdm68rs0j5lzhamdbl";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
