{ stdenv, fetchurl, hostPlatform, buildPackages, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  kversion = "4.16.8";
  pversion = "rt3";
  version = "${kversion}-${pversion}";
  extraMeta.branch = "4.14";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${kversion}.tar.xz";
    sha256 = "1z4q7khag48wildvq4hf4vwaipkfbh9yywm2m9zfj43vk1ysvyp4";
  };
} // (args.argsOverride or {}))
