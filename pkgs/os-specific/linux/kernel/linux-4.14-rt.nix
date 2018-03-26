{ stdenv, fetchurl, hostPlatform, buildPackages, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  kversion = "4.14.29";
  pversion = "rt25";
  version = "${kversion}-${pversion}";
  extraMeta.branch = "4.14";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${kversion}.tar.xz";
    sha256 = "06a6q69jwvggns5rf473nfgfwlkfyj8zs6vrjppwf8lrrrq7pxhq";
  };
} // (args.argsOverride or {}))
