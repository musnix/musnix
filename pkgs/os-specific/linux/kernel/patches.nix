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
      kversion = "3.18.46";
      pversion = "rt50";
      sha256 = "1p35w13xy4bgfv8bfzgwa2w4d61i4bkycs417iny6xdlrvx68m0m";
    };

  realtimePatch_4_1 = realtimePatch
    { branch = "4.1";
      kversion = "4.1.37";
      pversion = "rt43";
      sha256 = "0jq31y8by3lm69mxc22qv9a8hmg3nb83rkqkwsh6mpdwpij506lc";
    };

  realtimePatch_4_4 = realtimePatch
    { branch = "4.4";
      kversion = "4.4.39";
      pversion = "rt50";
      sha256 = "1k6hlsc32rsnb7zvgx4dx8mgx51yxcin4vmn15cndm0713y5isjq";
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
