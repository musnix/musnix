{ fetchurl, buildLinuxRT, ... } @ args:
let
  metadata = (import ./metadata.nix).kernels."3.18";
in
buildLinuxRT (args // rec {
  inherit (metadata) kversion pversion;
  version = "${kversion}-${pversion}";
  extraMeta.branch = metadata.branch;

  src = fetchurl {
    inherit (metadata) sha256;
    url = "mirror://kernel/linux/kernel/v3.x/linux-${kversion}.tar.xz";
  };
} // (args.argsOverride or {}))
