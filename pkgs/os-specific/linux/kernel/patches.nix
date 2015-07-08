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
      kversion = "3.14.36";
      version = "rt34";
      url = "https://www.kernel.org/pub/linux/kernel/projects/rt/3.14/older/patch-3.14.36-rt34.patch.xz";
      sha256 = "098nnnbh989rci2x2zmsjdj5h6ivgz4yp3qa30494rbay6v8faiv";
    };

 }
