{ fetchurl, buildLinuxRT, ... } @ args:

buildLinuxRT (args // rec {
  kversion = "4.9.35";
  pversion = "rt25";
  version = "${kversion}-${pversion}";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${kversion}.tar.xz";
    sha256 = "0dklbr686ygvpbjs6chra9vycfvp8xjgkvapai14lglzsx72749l";
  };
} // (args.argsOverride or {}))
