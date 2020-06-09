{ stdenv, fetchurl, hostPlatform, buildPackages, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  kversion = "5.6.14";
  pversion = "rt7";
  version = "${kversion}-${pversion}";
  extraMeta.branch = "5.6";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v5.x/linux-${kversion}.tar.xz";
    sha256 = "18vyxi64i93v4qyky5q62kkasm1da7wmz91xfkx3j7ki84skyxik";
  };
} // (args.argsOverride or {}))
