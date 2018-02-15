{ stdenv, fetchurl, hostPlatform, buildPackages, perl, buildLinux, ... } @ args:

with stdenv.lib;

buildLinux (args // rec {
  kversion = "4.13.7";
  pversion = "rt1";
  version = "${kversion}-${pversion}";
    # branchVersion needs to be x.y
  extraMeta.branch = concatStrings (intersperse "." (take 2 (splitString "." version)));

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${kversion}.tar.xz";
    sha256 = "16vjjl3qw0a8ci6xbnywhb8bpr3ccbs0i6xa54lc094cd5gvx4v3";
  };

  kernelPatches = args.kernelPatches;

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
