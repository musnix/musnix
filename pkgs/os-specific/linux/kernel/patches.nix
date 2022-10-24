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

  realtimePatch_5_4  = realtimePatch metadata."5.4";
  realtimePatch_5_6  = realtimePatch metadata."5.6";
  realtimePatch_5_9  = realtimePatch metadata."5.9";
  realtimePatch_5_16  = realtimePatch metadata."5.16";
  realtimePatch_5_17  = realtimePatch metadata."5.17";
  realtimePatch_5_19  = realtimePatch metadata."5.19";

}
