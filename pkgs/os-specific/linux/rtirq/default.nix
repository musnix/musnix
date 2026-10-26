{
  stdenv,
  fetchurl,
  util-linux,
  lib,
}:

stdenv.mkDerivation rec {
  pname = "rtirq";
  version = "20240905";

  src = fetchurl {
    urls = [
      "http://www.rncbc.org/archive/rtirq-${version}.tar.gz"
      "https://www.rncbc.org/archive/old/rtirq-${version}.tar.gz"
    ];
    sha256 = "sha256-HUy0tpQupf3pzWKQNlvxobJk/1e1gGwJl6sTf0/F5PM=";
  };

  postPatch = ''
    patchShebangs rtirq.sh
    substituteInPlace rtirq.sh \
      --replace "/sbin /usr/sbin /bin /usr/bin /usr/local/bin" "${util-linux}/bin"
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp rtirq.sh $out/bin/rtirq
  '';

  meta = with lib; {
    description = "IRQ thread tuning for realtime kernels";
    homepage = "http://www.rncbc.org/jack/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ henrytill ];
  };
}
