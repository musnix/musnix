{ stdenv, fetchurl, utillinux }:

stdenv.mkDerivation rec {
  name = "rtirq";
  version = "20210113";

  src = fetchurl {
    url = "http://www.rncbc.org/archive/${name}-${version}.tar.gz";
    sha256 = "0yb1d640z93kspwxihqsra26fyhazp24grcdy3fdkbnffprl5nx1";
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
