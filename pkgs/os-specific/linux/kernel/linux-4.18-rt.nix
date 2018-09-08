{ stdenv, fetchurl, hostPlatform, buildPackages, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  kversion = "4.18.5";
  pversion = "rt3";
  version = "${kversion}-${pversion}";
  extraMeta.branch = "4.18";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${kversion}.tar.xz";
    sha256 = "1ga7ys6s5d9dk1ly9722sbik1y6kbc3w6nw9pw86zpzdh0v0l2gv";
  };
} // (args.argsOverride or {}))
