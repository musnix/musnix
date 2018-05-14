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
      kversion = "4.1.40";
      pversion = "rt48";
      sha256 = "0b5sdzlzi6bjmbvmhxb72w73pafr30yawzjd4is7vzcd8b71y227";
    };

  realtimePatch_4_4 = realtimePatch
    { branch = "4.4";
      kversion = "4.4.70";
      pversion = "rt83";
      sha256 = "1kannihx8hcykdachi14myapsdgpwxl2gkwfy0ylb9khjp6zw9yw";
    };

  realtimePatch_4_9 = realtimePatch
    { branch = "4.9";
      kversion = "4.9.35";
      pversion = "rt25";
      sha256 = "0vm7dpdaspwyccx2lh6sycfcaaiw1439fpnhypm5cya0ymsnz0fj";
    };

  realtimePatch_4_11 = realtimePatch
    { branch = "4.11";
      kversion = "4.11.12";
      pversion = "rt14";
      sha256 = "0zh0xfw34abwaadlskdgbmm9cgz88kw7ss5scq4x821qx9n11a0b";
    };

  realtimePatch_4_13 = realtimePatch
    { branch = "4.13";
      kversion = "4.13.7";
      pversion = "rt1";
      sha256 = "0jmwwy6yf19apqh6m8cc3k16czgjb1vlhg02r78zpxx77w793x2z";
    };

  realtimePatch_4_14 = realtimePatch
    { branch = "4.14";
      kversion = "4.14.40";
      pversion = "rt30";
      sha256 = "0xfzi7h60hlm5m0sw13a4g33c0x0r8p9fqfhdlxdwzbs92pywa5x";
    };
}
