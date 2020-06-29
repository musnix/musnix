#! /usr/bin/env nix-shell
#! nix-shell -i bash -p nixfmt

BRANCHES=(
  "3.18"
  "4.1" "4.4" "4.9" "4.11" "4.14" "4.16" "4.18" "4.19"
  "5.0" "5.4" "5.6"
)

OUTPUT=metadata.nix
OUTPUT_TMP=$OUTPUT.tmp

URL_BASE_KERNEL="mirror://kernel/linux/kernel"
URL_BASE_RT="https://mirrors.edge.kernel.org/pub/linux/kernel/projects/rt"

function update_branch() {
  kernel_branch=$1
  >&2 echo "- updating kernel-branch: $kernel_branch"
  patch_version_string=$(
    curl -q $URL_BASE_RT/$kernel_branch/sha256sums.asc 2>/dev/null |
    sed -rn 's/^.*patch-(.*).patch.xz.*$/\1/p' |
    sort -V | tail -n 1
  )
  kernel_version=$(echo $patch_version_string | cut -d'-' -f1)
  patch_version=$(echo $patch_version_string | cut -d'-' -f2)
  patch_url="$URL_BASE_RT/$kernel_branch/older/patch-$patch_version_string.patch.xz"
  patch_hash=$(nix-prefetch-url $patch_url)
  kernel_version_major=$(echo $kernel_version | cut -d'.' -f1)
  kernel_url="$URL_BASE_KERNEL/v$kernel_version_major.x/linux-$kernel_version.tar.xz"
  kernel_hash=$(nix-prefetch-url $kernel_url)
  >&2 echo "+ kernel-version: $kernel_version"
  >&2 echo "+ kernel-url: $kernel_url"
  >&2 echo "+ kernel-hash: $kernel_hash"
  >&2 echo "+ patch-version: $patch_version"
  >&2 echo "+ patch-url: $patch_url"
  >&2 echo "+ patch-hash: $patch_hash"
  printf 'kernels."%s" = { branch = "%s"; kversion = "%s"; pversion = "%s"; sha256 = "%s"; };\n' \
    $kernel_branch $kernel_branch $kernel_version $patch_version $kernel_hash
  printf 'patches."%s" = { branch = "%s"; kversion = "%s"; pversion = "%s"; sha256 = "%s"; };\n' \
    $kernel_branch $kernel_branch $kernel_version $patch_version $patch_hash
}

function main() {
  echo "{" > $OUTPUT_TMP
  for b in "${BRANCHES[@]}"; do
    update_branch $b >> $OUTPUT_TMP
  done
  echo "}" >> $OUTPUT_TMP
  nixfmt $OUTPUT_TMP
  mv $OUTPUT_TMP $OUTPUT
}

main
