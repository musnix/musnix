{ stdenv, fetchurl, hostPlatform, buildPackages, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  kversion = "4.18.12";
  pversion = "rt7";
  version = "${kversion}-${pversion}";
  extraMeta.branch = "4.18";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${kversion}.tar.xz";
    sha256 = "1icz2nkhkb1xhpmc9gxfhc3ywkni8nywk25ixrmgcxp5rgcmlsl4";
  };
} // (args.argsOverride or {}))
