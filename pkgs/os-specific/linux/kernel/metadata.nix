let
  kernel  = branch: kversion: pversion: sha256: { inherit branch kversion pversion sha256; };
  patches = branch: kversion: pversion: sha256: { inherit branch kversion pversion sha256; };
in {
  kernels = {
    "6.1"  = kernel "6.1"  "6.1.90" "rt30" "07cfg0chssvpc4mqls3aln6s4lqjp6k4x2n63wndmkjgfqpdg8w3";
    "6.6"  = kernel "6.6"  "6.6.30" "rt30" "1ilwmgpgvddwkd9nx5999cb6z18scjyq7jklid26k1hg7f35nsmn";
    "6.8"  = kernel "6.8"  "6.8.2"  "rt11" "013xs37cnan72baqvmn2qrcbs5bbcv1gaafrcx3a166gbgc25hws";
    "6.9"  = kernel "6.9"  "6.9"    "rt5"  "0jc14s7z2581qgd82lww25p7c4w72scpf49z8ll3wylwk3xh3yi4";
    "6.11" = kernel "6.11" "6.11"   "rt7"  "sha256-VdLGwCXrwngQx0jWYyXdW8YB6NMvhYHZ53ZzUpvayy4=";
  };
  patches = {
    "6.1"  = patches "6.1"  "6.1.90" "rt30" "0sgwxdy4bzjqr74nrmsyw1f2lcqpapxmkj5yywf7jkqa20jkdvgr";
    "6.6"  = patches "6.6"  "6.6.30" "rt30" "05n6fyy5c0f18v4n1rfkcvqj8s0p5x6s16qq5mnmya86rhdr6gn7";
    "6.8"  = patches "6.8"  "6.8.2"  "rt11" "0rchqyzxmvf1zpp5rndx9vxj7wbz424d4pvp5kfm1bw8aypkq1mh";
    "6.9"  = patches "6.9"  "6.9"    "rt5"  "0sh5ajj8zm44l4dicyxy99g2fjp661i9jxilb94684cf8l39lwg1";
    "6.11" = patches "6.11" "6.11"   "rt7"  "sha256-dFnNr2ssgoir8wbWYJ8EfkMYIb0hUDl0TS1+tQU1V/8=";
  };
}
