{ stdenv, fetchurl, hostPlatform, buildPackages, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  kversion = "4.19.124";
  pversion = "rt53";
  version = "${kversion}-${pversion}";
  extraMeta.branch = "4.19";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${kversion}.tar.xz";
    sha256 = "005dznldnj1m03cbkc5pd2q2cv9jj1j6a0x2vh4p79ypg4c01nfm";
  };
} // (args.argsOverride or {}))
