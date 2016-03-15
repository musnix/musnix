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
      kversion = "3.18.28";
      pversion = "rt28";
      sha256 = "1i9jp272v41ag9z0r255k507dz5q81kddab8wzbmmihhr5wwv1yd";
    };

  realtimePatch_4_1 = realtimePatch
    { branch = "4.1";
      kversion = "4.1.19";
      pversion = "rt22";
      sha256 = "04iyrghpmw070d6gvq0qxyzlzi40mrvj8gx66j7kdm22ihypzrwj";
    };

  realtimePatch_4_4 = realtimePatch
    { branch = "4.4";
      kversion = "4.4.4";
      pversion = "rt11";
      sha256 = "0kvwfp11wfj75fhdggcvl9acb9rg7kx1305kgg1w6ay1b7h0b5c1";
    };

}
