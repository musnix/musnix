{ stdenv, fetchurl, hostPlatform, buildPackages, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  kversion = "4.19.31";
  pversion = "rt18";
  version = "${kversion}-${pversion}";
  extraMeta.branch = "4.19";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${kversion}.tar.xz";
    sha256 = "02r822zhs1xcjy6jpf9fv0h4br47drd3xssxapr2b45y8anr1aks";
  };
} // (args.argsOverride or {}))
