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

  realtimePatch_3_18 = realtimePatch
    { branch = "3.18";
      kversion = "3.18.51";
      pversion = "rt57";
      sha256 = "057f39vn520lf1my9fdfjfbmfm4jp6qwpsq068ci96q983jn6mvg";
    };

  realtimePatch_4_1 = realtimePatch
    { branch = "4.1";
      kversion = "4.1.39";
      pversion = "rt47";
      sha256 = "1bs87bkkiz49mcyb2cx4lfvpjvr2zcvzxs333zvspamkglsks5p9";
    };

  realtimePatch_4_4 = realtimePatch
    { branch = "4.4";
      kversion = "4.4.66";
      pversion = "rt79";
      sha256 = "055as8mgs6nx452xvpzpfn0nsq0m5im9nmq8zfjyijfs0rifm7rf";
    };

  realtimePatch_4_6 = realtimePatch rec
    { branch = "4.6";
      kversion = "4.6.7";
      pversion = "rt14";
      sha256 = "17jshwc89d3nrajsbym3qb5n69z91f2phggajxikxgh3ign8yp2k";
    };

  realtimePatch_4_8 = realtimePatch rec
    { branch = "4.8";
      kversion = "4.8.15";
      pversion = "rt10";
      sha256 = "1zsrjx1sljn7wsr4yvxq4cjmvzl25c3myqvps1ksv1qjcwx3bg21";
    };

  realtimePatch_4_9 = realtimePatch rec
    { branch = "4.9";
      kversion = "4.9.27";
      pversion = "rt18";
      sha256 = "1ig0g2pap26nqlqib971mh6zh3mfnhiszc357ay42vkiqf4sxkfq";
    };
}
