{ stdenv, fetchurl, utillinux }:

stdenv.mkDerivation rec {
  name = "rtirq";
  version = "20150216";

  src = fetchurl {
    url = "http://www.rncbc.org/jack/${name}-${version}.tar.gz";
    sha256 = "14wv9rwwplnn3lq5a3givxn2h57kczqmkapc7sgpqlp1xwy16i1b";
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
