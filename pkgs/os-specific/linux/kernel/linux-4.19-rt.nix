{ stdenv, fetchurl, hostPlatform, buildPackages, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  kversion = "4.19.23";
  pversion = "rt14";
  version = "${kversion}-${pversion}";
  extraMeta.branch = "4.19";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${kversion}.tar.xz";
    sha256 = "02hkiz5vlx2qhyi1hxar9d1cr2gfnrpjdrjjkh83yzxci9kjb6rd";
  };
} // (args.argsOverride or {}))
