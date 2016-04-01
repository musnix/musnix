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
      kversion = "3.14.64";
      pversion = "rt67";
      sha256 = "1l6ks153ff7cl8irmbjs1378anyij2w3d0ga8bpisgqj3ryflnmf";
    };

  realtimePatch_3_18 = realtimePatch
    { branch = "3.18";
      kversion = "3.18.28";
      pversion = "rt28";
      sha256 = "1i9jp272v41ag9z0r255k507dz5q81kddab8wzbmmihhr5wwv1yd";
    };

  realtimePatch_4_1 = realtimePatch
    { branch = "4.1";
      kversion = "4.1.20";
      pversion = "rt23";
      sha256 = "1iyi8f35ryvbiy7xbkhpmiiy4nadqnv7kpl7mz4i6njs9zbjdgk6";
    };

  realtimePatch_4_4 = realtimePatch
    { branch = "4.4";
      kversion = "4.4.6";
      pversion = "rt12";
      sha256 = "0j1bjlm2vs9bzdnwpq0agjq04spmnhi4jjnq59i8zvdykpi26ac3";
    };

}
