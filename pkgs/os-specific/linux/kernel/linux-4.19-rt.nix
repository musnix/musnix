{ stdenv, fetchurl, hostPlatform, buildPackages, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  kversion = "4.19.15";
  pversion = "rt12";
  version = "${kversion}-${pversion}";
  extraMeta.branch = "4.19";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${kversion}.tar.xz";
    sha256 = "0v9nbkxc017ydcah5q0yhrlq1f7awc33m6w4gpif2f0wvxfimxkq";
  };
} // (args.argsOverride or {}))
