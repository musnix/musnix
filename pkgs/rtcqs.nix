{pkgs, fetchPypi, ... }:

pkgs.python3.pkgs.buildPythonApplication rec {
    pname = "rtcqs";
    version = "0.6.2";
    format = "pyproject";
    buildInputs = [
      pkgs.python3.pkgs.setuptools
    ];
    src = fetchPypi {
      inherit pname version;
      hash = "sha256-DfeV9kGhdMf6hZ1iNJ0L3HUn7m8c1gRK5cjtJNUAvJI=";
    };
}
  
