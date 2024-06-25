{ pkgs, fetchPypi, ... }:

pkgs.python3.pkgs.buildPythonApplication rec {
  pname = "rtcqs";
  version = "0.6.2";
  format = "pyproject";

  # Dont check that the gui portion of the rtcqs package (rtcqs_gui) can be
  # run. It uses PySimpleGUI, which, though it is available in nixpkgs,
  # doesn't work properly.  It is a deliberately obfuscated commercial
  # library, and isn't readily fixable.  rtcqs_gui offers no functionality
  # that isn't offered by the command-line utility rtcqs.
  #
  # We set 'pythonRuntimeDepsCheck = "true"' in order to skip the Nix
  # dependency checking that causes it to find a dependency on PySimpleGUI
  # (run the UNIX "true" command rather than the default command), making
  # the build complete rather than erroring out.
  pythonRuntimeDepsCheckHook = "true";

  buildInputs = [ pkgs.python3.pkgs.setuptools ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DfeV9kGhdMf6hZ1iNJ0L3HUn7m8c1gRK5cjtJNUAvJI=";
  };
}
