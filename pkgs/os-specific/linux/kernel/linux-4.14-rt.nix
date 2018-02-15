{ stdenv, fetchurl, hostPlatform, buildPackages, perl, buildLinux, ... } @ args:

with stdenv.lib;

buildLinux (args // rec {
  kversion = "4.14.18";
  pversion = "rt15";
  version = "${kversion}-${pversion}";
  # branchVersion needs to be x.y
  extraMeta.branch = concatStrings (intersperse "." (take 2 (splitString "." version)));

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${kversion}.tar.xz";
    sha256 = "0m73kz9jg6mylgql0zzypm76g6x7m3bq7dklivhkm4ldqg0r8sl6";
  };

  kernelPatches = args.kernelPatches;

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
