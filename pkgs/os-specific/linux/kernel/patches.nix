{ stdenv, fetchurl }:

let

  realtimePatch =
    { branch
    , kversion
    , pversion
    , url ? "https://www.kernel.org/pub/linux/kernel/projects/rt/${branch}/patch-${kversion}-${pversion}.patch.xz"
    , sha256
    }:
    { name  = "rt-${kversion}-${pversion}";
      patch = fetchurl {
        inherit url sha256;
      };
    };

in rec {

  realtimePatch_3_14 = realtimePatch
    { branch = "3.14";
      kversion = "3.14.48";
      pversion = "rt48";
      sha256 = "1ddvm1mxv5rnj0gkkzijzg8w3bi6vwyvam1v3jp00860gsp9hcfm";
    };

  realtimePatch_3_18 = realtimePatch
    { branch = "3.18";
      kversion = "3.18.18";
      pversion = "rt15";
      sha256 = "05z6czzgnjw04l9bcglghi47pzbbs9p2hi50wh3w3z5idd3fg367";
    };

  realtimePatch_4_0 = realtimePatch
    { branch = "4.0";
      kversion = "4.0.8";
      pversion = "rt6";
      sha256 = "0x3in9rjcw7lja902nj8647lhmxw3dsnav0xm2jg1irjicqk77p8";
    };

  realtimePatch_4_1 = realtimePatch
    { branch = "4.1";
      kversion = "4.1.3";
      pversion = "rt3";
      sha256 = "15jwlnp7k51vgk8ccp40p2nimk2znmanidgka7rwhvgx9njx5a22";
    };

}
