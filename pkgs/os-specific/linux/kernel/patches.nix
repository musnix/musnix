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
      pversion = "rt64";
      sha256 = "088sbh2q0i7q9ff53acv50f8bpfqhshka4impxv2icjizvna045s";
    };

  realtimePatch_3_18 = realtimePatch
    { branch = "3.18";
      kversion = "3.18.27";
      pversion = "rt27";
      sha256 = "121dgxhlpbw5fybakkbm1i737b7yrp3dhhhagy72xbl5bd86bn01";
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
      kversion = "4.4.4";
      pversion = "rt11";
      sha256 = "0kvwfp11wfj75fhdggcvl9acb9rg7kx1305kgg1w6ay1b7h0b5c1";
    };

}
