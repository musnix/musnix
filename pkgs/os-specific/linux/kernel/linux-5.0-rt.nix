{ fetchurl, buildLinuxRT, ... } @ args:
let
  metadata = (import ./metadata.nix).kernels."5.0";
in
buildLinuxRT (args // rec {
  inherit (metadata) kversion pversion;
  version = "${kversion}-${pversion}";
  extraMeta.branch = metadata.branch;

  src = fetchurl {
    inherit (metadata) sha256;
    url = "mirror://kernel/linux/kernel/v5.x/linux-${kversion}.tar.xz";
  };
} // (args.argsOverride or {}))
