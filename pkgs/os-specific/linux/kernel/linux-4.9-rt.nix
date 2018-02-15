{ stdenv, hostPlatform, fetchurl, buildPackages, perl, buildLinux, ... } @ args:

with stdenv.lib;

buildLinux (args // rec {
  kversion = "4.9.35";
  pversion = "rt25";
  version = "${kversion}-${pversion}";
    # branchVersion needs to be x.y
  extraMeta.branch = concatStrings (intersperse "." (take 2 (splitString "." version)));

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${kversion}.tar.xz";
    sha256 = "0dklbr686ygvpbjs6chra9vycfvp8xjgkvapai14lglzsx72749l";
  };

  kernelPatches = args.kernelPatches;

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
