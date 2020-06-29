{ fetchurl, buildLinuxRT, ... } @ args:

buildLinuxRT (args // rec {
  kversion = "5.4.44";
  pversion = "rt26";
  version = "${kversion}-${pversion}";
  extraMeta.branch = "5.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v5.x/linux-${kversion}.tar.xz";
    sha256 = "0fc4nsv1zwlknvfv1bzkjlq2vlx28wfl09hg2p7r8cn7a77bphlp";
  };
} // (args.argsOverride or {}))
