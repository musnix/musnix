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

  metadata = (import ./metadata.nix).patches;

in {

  realtimePatch_3_18 = realtimePatch metadata."3.18";
  realtimePatch_4_1  = realtimePatch metadata."4.1";
  realtimePatch_4_4  = realtimePatch metadata."4.4";
  realtimePatch_4_9  = realtimePatch metadata."4.9";
  realtimePatch_4_11 = realtimePatch metadata."4.11";
  realtimePatch_4_13 = realtimePatch metadata."4.13";
  realtimePatch_4_14 = realtimePatch metadata."4.14";
  realtimePatch_4_16 = realtimePatch metadata."4.16";
  realtimePatch_4_18 = realtimePatch metadata."4.18";
  realtimePatch_4_19 = realtimePatch metadata."4.19";
  realtimePatch_5_0  = realtimePatch metadata."5.0";
  realtimePatch_5_4  = realtimePatch metadata."5.4";
  realtimePatch_5_6  = realtimePatch metadata."5.6";

}
