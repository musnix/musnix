{ fetchurl, buildLinuxRT, ... } @ args:
let
  metadata = (import ./metadata.nix).kernels."4.13";
in
buildLinuxRT (args // rec {
  inherit (metadata) kversion pversion;
  version = "${kversion}-${pversion}";
  extraMeta.branch = metadata.branch;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${kversion}.tar.xz";
    sha256 = "16vjjl3qw0a8ci6xbnywhb8bpr3ccbs0i6xa54lc094cd5gvx4v3";
  };
} // (args.argsOverride or {}))
