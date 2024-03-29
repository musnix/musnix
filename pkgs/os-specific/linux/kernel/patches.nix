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
  realtimePatch_6_1  = realtimePatch metadata."6.1";
  realtimePatch_6_6  = realtimePatch metadata."6.6";
  realtimePatch_6_8  = realtimePatch metadata."6.8";
}
