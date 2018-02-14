{ stdenv, hostPlatform, fetchurl, buildPackages, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  kversion = "4.1.40";
  pversion = "rt48";
  version = "${kversion}-${pversion}";
  extraMeta.branch = "4.1";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${kversion}.tar.xz";
    sha256 = "1w7pf12grzn2bcnx2q25rsdmanwya1dgqica5pi6yw5pl2l0mnz6";
  };
} // (args.argsOverride or {}))
