{ fetchurl, buildLinuxRT, ... } @ args:

buildLinuxRT (args // rec {
  kversion = "4.13.7";
  pversion = "rt1";
  version = "${kversion}-${pversion}";
  extraMeta.branch = "4.11";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${kversion}.tar.xz";
    sha256 = "16vjjl3qw0a8ci6xbnywhb8bpr3ccbs0i6xa54lc094cd5gvx4v3";
  };
} // (args.argsOverride or {}))
