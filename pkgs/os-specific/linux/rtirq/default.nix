{ stdenv, fetchurl, utillinux }:

stdenv.mkDerivation rec {
  name = "rtirq";
  version = "20180209";

  src = fetchurl {
    url = "http://www.rncbc.org/jack/${name}-${version}.tar.gz";
    sha256 = "09phbn8cq5m39dz3mijrsb3p4vfp7c4ngsk1mvs8qm09n7zpqrfs";
  };

  phases = [ "unpackPhase" "patchPhase" "installPhase" ];

  patchPhase = ''
    patchShebangs rtirq.sh
    substituteInPlace rtirq.sh \
      --replace "/sbin /usr/sbin /bin /usr/bin /usr/local/bin" "${utillinux}/bin"
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp rtirq.sh $out/bin/rtirq
  '';

  meta = with stdenv.lib; {
    description = "IRQ thread tuning for realtime kernels";
    homepage = http://www.rncbc.org/jack/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ henrytill ];
  };
}
