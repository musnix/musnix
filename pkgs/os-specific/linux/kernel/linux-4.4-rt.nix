{ stdenv, hostPlatform, fetchurl, buildPackages, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  kversion = "4.4.70";
  pversion = "rt83";
  version = "${kversion}-${pversion}";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${kversion}.tar.xz";
    sha256 = "1yid0y4ha7mrn9ns037kjsrgbqffcz2c2p27rgn92jh4m5nb7a60";
  };
} // (args.argsOverride or {}))
