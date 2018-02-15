{ stdenv, fetchurl, hostPlatform, buildPackages, perl, buildLinux, ... } @ args:

with stdenv.lib;

buildLinux (args // rec {
  kversion = "4.11.12";
  pversion = "rt14";
  version = "${kversion}-${pversion}";
    # branchVersion needs to be x.y
  extraMeta.branch = concatStrings (intersperse "." (take 2 (splitString "." version)));

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${kversion}.tar.xz";
    sha256 = "14k10g9w8dp3lmw1qjns395a2fcaq2iw1jijss5npxllh3hx8drf";
  };

  kernelPatches = args.kernelPatches;

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
