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
      kversion = "3.14.65";
      pversion = "rt68";
      sha256 = "1xzwk1v7iv82wkdj4n3vclha1vz2678qqkczrvsx0apdxqcnpp8c";
    };

  realtimePatch_3_18 = realtimePatch
    { branch = "3.18";
      kversion = "3.18.29";
      pversion = "rt30";
      sha256 = "05n69kywqn92jg0x2l8qpyv2xwxs66myj7yv739x592yzihzjpyp";
    };

  realtimePatch_4_1 = realtimePatch
    { branch = "4.1";
      kversion = "4.1.20";
      pversion = "rt23";
      sha256 = "1iyi8f35ryvbiy7xbkhpmiiy4nadqnv7kpl7mz4i6njs9zbjdgk6";
    };

  realtimePatch_4_4 = realtimePatch rec
    { branch = "4.4";
      kversion = "4.4.15";
      pversion = "rt23";
      sha256 = "1i58dibdd8lv7gmap55px9kkv32xzxkh8mml28v9r97kl32dr9da";
    };

  realtimePatch_4_6 = realtimePatch rec
    { branch = "4.6";
      kversion = "4.6.5";
      pversion = "rt9";
      sha256 = "0mwaj5n5s79dakxga42lvqr18h6icrp7wk6vj6phjya0a6szzsjb";
    };
}
