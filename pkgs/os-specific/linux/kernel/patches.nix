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
      pversion = "rt63";
      sha256 = "1zi04l79m7m981g1x4plgss8920rcyzi9hhif6a3dr49ypwpcfj2";
    };

  realtimePatch_3_18 = realtimePatch
    { branch = "3.18";
      kversion = "3.18.27";
      pversion = "rt26";
      sha256 = "02ajg1wz8xq12rg7ca5a56wgkqmgrb78ia1mx4i8z42n2plhkzll";
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
      pversion = "rt18";
      sha256 = "12zyfk9wpyw6yg4ava3fl94lss9w20k3rmpasrfws1jki56qg4vy";
    };

  realtimePatch_4_4 = realtimePatch
    { branch = "4.4";
      kversion = "4.4.3";
      pversion = "rt9";
      sha256 = "09vbvwc4yyb8r3pqaj33v4afbnzvm4qpskfvbgwrl524s586jr8i";
    };

}
