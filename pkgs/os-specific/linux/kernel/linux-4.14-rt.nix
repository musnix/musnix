{ stdenv, fetchurl, hostPlatform, buildPackages, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  kversion = "4.14.40";
  pversion = "rt30";
  version = "${kversion}-${pversion}";
  extraMeta.branch = "4.14";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${kversion}.tar.xz";
    sha256 = "03nh71nqgifkamkb0gn12jny5h3lbn5kmpdy0ff886wyrl34sw6l";
  };
} // (args.argsOverride or {}))
