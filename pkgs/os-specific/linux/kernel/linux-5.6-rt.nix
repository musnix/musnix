{ fetchurl, buildLinuxRT, ... } @ args:

buildLinuxRT (args // rec {
  kversion = "5.6.17";
  pversion = "rt9";
  version = "${kversion}-${pversion}";
  extraMeta.branch = "5.6";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v5.x/linux-${kversion}.tar.xz";
    sha256 = "17kzalz8z6svv6nwa3dbmf7nyvpb2wwwyabj19vdwf6v05a28fn3";
  };
} // (args.argsOverride or {}))
