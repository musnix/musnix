{ stdenv, fetchurl }:

let

  realtimePatch =
    { branch
    , kversion
    , version
    , url ? "https://www.kernel.org/pub/linux/kernel/projects/rt/${branch}/patch-${kversion}-${version}.patch.xz"
    , sha256
    }:
    { name  = "rt-${kversion}-${version}";
      patch = fetchurl {
        inherit url sha256;
      };
    };

in rec {

  realtimePatch_3_14 = realtimePatch
    { branch = "3.14";
      kversion = "3.14.48";
      version = "rt48";
      sha256 = "1ddvm1mxv5rnj0gkkzijzg8w3bi6vwyvam1v3jp00860gsp9hcfm";
    };

  realtimePatch_3_18 = realtimePatch
    { branch = "3.18";
      kversion = "3.18.17";
      version = "rt14";
      sha256 = "063ah6a47b48xz38bk4l3mhl8n7lqyc4h1w9ii5rngd20lzgm4qy";
    };

  realtimePatch_4_0 = realtimePatch
    { branch = "4.0";
      kversion = "4.0.8";
      version = "rt6";
      sha256 = "0x3in9rjcw7lja902nj8647lhmxw3dsnav0xm2jg1irjicqk77p8";
    };

 }
