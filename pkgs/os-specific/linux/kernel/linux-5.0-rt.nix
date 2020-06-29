{ fetchurl, buildLinuxRT, ... } @ args:

buildLinuxRT (args // rec {
  kversion = "5.0.19";
  pversion = "rt11";
  version = "${kversion}-${pversion}";
  extraMeta.branch = "5.0";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v5.x/linux-${kversion}.tar.xz";
    sha256 = "1v6r2jifm3r56rj7d9w1x3g8va3snzmz7lmgk971ihdg9p3dbw0b";
  };
} // (args.argsOverride or {}))
