{ stdenv, fetchurl, hostPlatform, buildPackages, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  kversion = "4.19.25";
  pversion = "rt16";
  version = "${kversion}-${pversion}";
  extraMeta.branch = "4.19";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${kversion}.tar.xz";
    sha256 = "0ccpj57pv2rw78a4j5mg9sz7a37k0sn5glbn2rs6yvp9ss81vivy";
  };
} // (args.argsOverride or {}))
