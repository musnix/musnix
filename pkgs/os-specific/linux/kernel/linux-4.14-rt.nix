{ stdenv, fetchurl, hostPlatform, buildPackages, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  kversion = "4.14.103";
  pversion = "rt55";
  version = "${kversion}-${pversion}";
  extraMeta.branch = "4.14";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${kversion}.tar.xz";
    sha256 = "04bag7q9gwd2apbmzmniq3w0cq70jvhmmvwwl9frdrf9whs3x93s";
  };
} // (args.argsOverride or {}))
