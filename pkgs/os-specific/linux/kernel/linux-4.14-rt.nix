{ stdenv, fetchurl, hostPlatform, buildPackages, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  kversion = "4.14.34";
  pversion = "rt27";
  version = "${kversion}-${pversion}";
  extraMeta.branch = "4.14";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${kversion}.tar.xz";
    sha256 = "1f9bl4qw61xw49y5xz1wyilg8gh0wv9k868fh8n3hp17hm66qavq";
  };
} // (args.argsOverride or {}))
