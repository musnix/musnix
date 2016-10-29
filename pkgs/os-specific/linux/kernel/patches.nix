{ stdenv, fetchurl }:

let

  realtimePatch =
    { branch
    , kversion
    , pversion
    , url ? "https://www.kernel.org/pub/linux/kernel/projects/rt/${branch}/older/patch-${kversion}-${pversion}.patch.xz"
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
      kversion = "3.14.73";
      pversion = "rt78";
      sha256 = "0fxqh4vdgzkl5jfc231lh7zmqy6s1ygx8brxw0ja7v4hh09rfshz";
    };

  realtimePatch_3_18 = realtimePatch
    { branch = "3.18";
      kversion = "3.18.36";
      pversion = "rt38";
      sha256 = "051bc6cyy3l6wkvnzss7rdm87mldlv1rsncd45s25h5qf55gjimc";
    };

  realtimePatch_4_1 = realtimePatch
    { branch = "4.1";
      kversion = "4.1.33";
      pversion = "rt38";
      sha256 = "0d31yxb8w29mpkqwf1zrpls0np2rnzrk3b6k38i2rk60dp43n7nj";
      url = "https://www.kernel.org/pub/linux/kernel/projects/rt/4.1/patch-4.1.33-rt38.patch.xz";
    };

  realtimePatch_4_4 = realtimePatch rec
    { branch = "4.4";
      kversion = "4.4.23";
      pversion = "rt33";
      sha256 = "1zlm5qj8am7k6rjddb08x075ik75qg52ysnjm4x46gyk6prdjjwd";
      url = "https://www.kernel.org/pub/linux/kernel/projects/rt/4.4/patch-4.4.23-rt33.patch.xz";
    };

  realtimePatch_4_6 = realtimePatch rec
    { branch = "4.6";
      kversion = "4.6.7";
      pversion = "rt11";
      sha256 = "1ny3d6648rbm5lg5fi4gix7an6pa9jwa30sh2djp3mg29lzpivs9";
    };

  realtimePatch_4_8 = realtimePatch rec
    { branch = "4.8";
      kversion = "4.8.2";
      pversion = "rt3";
      sha256 = "0a6ysrmzxiaknmab0bbnlx32s6s25swrc4p9m5d4zi2a0dc19na3";
    };
}
