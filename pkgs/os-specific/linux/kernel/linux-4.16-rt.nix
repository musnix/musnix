{ stdenv, fetchurl, hostPlatform, buildPackages, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  kversion = "4.16.7";
  pversion = "rt1";
  version = "${kversion}-${pversion}";
  extraMeta.branch = "4.14";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${kversion}.tar.xz";
    sha256 = "0f81mxc5b3zf5m29bwc3afv07k60661zl18098cjjqv6qpvbwynq";
  };
} // (args.argsOverride or {}))
