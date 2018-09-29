{ stdenv, fetchurl, hostPlatform, buildPackages, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  kversion = "4.18.7";
  pversion = "rt5";
  version = "${kversion}-${pversion}";
  extraMeta.branch = "4.18";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${kversion}.tar.xz";
    sha256 = "0cgpb8zx7ckd9lmmaas6r1vszbz9lhrn4w1njw3yaw9a4rg44fzh";
  };
} // (args.argsOverride or {}))
