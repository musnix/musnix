{ stdenv, fetchurl, hostPlatform, buildPackages, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  kversion = "5.0.7";
  pversion = "rt5";
  version = "${kversion}-${pversion}";
  extraMeta.branch = "5.0";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v5.x/linux-${kversion}.tar.xz";
    sha256 = "1v2lxwamnfm879a9qi9fwp5zyvlzjw9qa0aizidjbiwz5dk7gq8n";
  };
} // (args.argsOverride or {}))
