{ stdenv, fetchurl, hostPlatform, buildPackages, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  kversion = "4.14.27";
  pversion = "rt21";
  version = "${kversion}-${pversion}";
  extraMeta.branch = "4.14";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${kversion}.tar.xz";
    sha256 = "1si8l3clpkyhwawrjxz6yzx7xl0v0k6dy1yf5qiwf1hsqx4s8489";
  };
} // (args.argsOverride or {}))
