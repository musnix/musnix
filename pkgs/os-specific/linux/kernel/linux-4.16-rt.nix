{ fetchurl, buildLinuxRT, ... } @ args:

buildLinuxRT (args // rec {
  kversion = "4.16.18";
  pversion = "rt12";
  version = "${kversion}-${pversion}";
  extraMeta.branch = "4.14";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${kversion}.tar.xz";
    sha256 = "089hx2hdd5r558mv8n0c7jciv2nj9v77df0lsplsbxx47dqns0j1";
  };
} // (args.argsOverride or {}))
