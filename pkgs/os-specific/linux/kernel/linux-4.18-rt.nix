{ fetchurl, buildLinuxRT, ... } @ args:

buildLinuxRT (args // rec {
  kversion = "4.18.16";
  pversion = "rt9";
  version = "${kversion}-${pversion}";
  extraMeta.branch = "4.18";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${kversion}.tar.xz";
    sha256 = "1rjjkhl8lz4y4sn7icy8mp6p1x7rvapybp51p92sanbjy3i19fmy";
  };
} // (args.argsOverride or {}))
