{ stdenv, fetchurl }:

let

  realtimePatch =
    { branch
    , kversion
    , version
    , url ? "https://www.kernel.org/pub/linux/kernel/projects/rt/${branch}/patch-${kversion}-${version}.patch.xz"
    , sha256
    }:
    { name  = "rt-${kversion}-${version}";
      patch = fetchurl {
        inherit url sha256;
      };
    };

in rec {

  realtimePatch_3_14 = realtimePatch
    { branch = "3.14";
      kversion = "3.14.46";
      version = "rt46";
      sha256 = "1ckba761y38x6s6w4r1c5xns7d0m824ldh8lhxxm1a0s485k573n";
    };

 }
