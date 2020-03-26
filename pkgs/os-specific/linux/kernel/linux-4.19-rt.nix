{ stdenv, fetchurl, hostPlatform, buildPackages, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  kversion = "4.19.106";
  pversion = "rt45";
  version = "${kversion}-${pversion}";
  extraMeta.branch = "4.19";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${kversion}.tar.xz";
    sha256 = "1nlwgs15mc3hlfhqw95pz7wisg8yshzrxzzq2a0y30mjm5vbvj33";
  };
} // (args.argsOverride or {}))
