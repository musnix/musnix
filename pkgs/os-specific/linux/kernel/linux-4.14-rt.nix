{ stdenv, fetchurl, hostPlatform, buildPackages, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  kversion = "4.14.24";
  pversion = "rt19";
  version = "${kversion}-${pversion}";
  extraMeta.branch = "4.14";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${kversion}.tar.xz";
    sha256 = "00cqhc8198f4gj6cpz7nblpgi5zh2145arjx1yp0p4gmswdjslds";
  };
} // (args.argsOverride or {}))
