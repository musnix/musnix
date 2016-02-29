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
      kversion = "3.14.61";
      pversion = "rt62";
      sha256 = "164aw8fxpzvchnda9jcdnv2amavmp51hycpfpks6ggr0zpnwl372";
    };

  realtimePatch_3_18 = realtimePatch
    { branch = "3.18";
      kversion = "3.18.27";
      pversion = "rt25";
      sha256 = "1civ70nfml6xxfvhjp0m4929ra5frzv446mwh2k1x595i5pkwyn1";
    };

  realtimePatch_4_0 = realtimePatch
    { branch = "4.0";
      kversion = "4.0.8";
      pversion = "rt6";
      sha256 = "0x3in9rjcw7lja902nj8647lhmxw3dsnav0xm2jg1irjicqk77p8";
    };

  realtimePatch_4_1 = realtimePatch
    { branch = "4.1";
      kversion = "4.1.15";
      pversion = "rt17";
      sha256 = "17bb6h44580srxh16m1p9z9s697rjvncv2h3648dpwjvy5mas4si";
    };

  realtimePatch_4_4 = realtimePatch
    { branch = "4.4";
      kversion = "4.4.3";
      pversion = "rt9";
      sha256 = "09vbvwc4yyb8r3pqaj33v4afbnzvm4qpskfvbgwrl524s586jr8i";
    };

}
