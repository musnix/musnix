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
      kversion = "3.14.51";
      pversion = "rt52";
      sha256 = "0hkr3xdw6m3lb43hd2pp5nziphd8pr8f8xmgpawrmhc4yac2m5nw";
    };

  realtimePatch_3_18 = realtimePatch
    { branch = "3.18";
      kversion = "3.18.21";
      pversion = "rt19";
      sha256 = "17d1q1wqxpzb8q3sq3z6ikmmxn943qrasb5rccqz912khanzvzxa";
    };

  realtimePatch_4_0 = realtimePatch
    { branch = "4.0";
      kversion = "4.0.8";
      pversion = "rt6";
      sha256 = "0x3in9rjcw7lja902nj8647lhmxw3dsnav0xm2jg1irjicqk77p8";
    };

  realtimePatch_4_1 = realtimePatch
    { branch = "4.1";
      kversion = "4.1.7";
      pversion = "rt8";
      sha256 = "0kdf69zh4ymld4zj10bjic3gj8d3gkpfvcsnpa00s5k7x7g2zd8n";
    };

}
