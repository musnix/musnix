musnix
======

Meta-module for Realtime Audio in NixOS

Very much work in progress, but the end goal is twofold:

1) musnix module
________________

A module that configures everything needed for good realtime audio performance,
so you can just import it into a NixOS config and do:

musnix.enable = true;
musnix.ffadoEnable = true;
musnix.alsaSeq = true;
musnix.alsaSeq.modules  = [ ];
etc...


2) configuration files
______________________

A set of NixOS audio configurations for different needs, using the musnix module.


The general form is modelled on https://github.com/rockfabrik/deployment and
https://github.com/aszlig/vuizvui
