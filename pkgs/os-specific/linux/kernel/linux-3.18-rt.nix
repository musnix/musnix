{ stdenv, hostPlatform, fetchurl, buildPackages, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  kversion = "3.18.51";
  pversion = "rt57";
  version = "${kversion}-${pversion}";
  extraMeta.branch = "3.18";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${kversion}.tar.xz";
    sha256 = "1346d00dnpfcazfa1wmpn2z7na4afkns6yd08xkq7249wzgi23gi";
  };
} // (args.argsOverride or {}))
