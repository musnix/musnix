{ stdenv, fetchurl, hostPlatform, buildPackages, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  kversion = "4.11.12";
  pversion = "rt14";
  version = "${kversion}-${pversion}";
  extraMeta.branch = "4.11";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${kversion}.tar.xz";
    sha256 = "14k10g9w8dp3lmw1qjns395a2fcaq2iw1jijss5npxllh3hx8drf";
  };
} // (args.argsOverride or {}))
