{ stdenv, fetchurl, hostPlatform, buildPackages, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  kversion = "4.16.12";
  pversion = "rt5";
  version = "${kversion}-${pversion}";
  extraMeta.branch = "4.14";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${kversion}.tar.xz";
    sha256 = "078if7mmlq4csv0d7x7rpsc8zs7m6rpz75h6878r0d2silsphw2n";
  };
} // (args.argsOverride or {}))
