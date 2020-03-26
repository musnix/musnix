{ stdenv, fetchurl, hostPlatform, buildPackages, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  kversion = "5.4.26";
  pversion = "rt17";
  version = "${kversion}-${pversion}";
  extraMeta.branch = "5.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v5.x/linux-${kversion}.tar.xz";
    sha256 = "1bqdiw4pjzwm7pxml2dl09bj85ijs82rq788c58681zgmvs796k6";
  };
} // (args.argsOverride or {}))
