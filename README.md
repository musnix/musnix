mixnix
======

Meta-module for Realtime Audio in NixOS

Very much work in progress, but the end goal is twofold:

1) mixnix module
________________

A module that configures everything needed for good realtime audio performance,
so you can just import it into a NixOS config and do:

mixnix.enable = true;
mixnix.ffadoEnable = true;
mixnix.alsaSeq = true;
mixnix.alsaSeq.modules  = [ ];
etc...


2) configuration files
______________________

A set of NixOS audio configurations for different needs, using the mixnix module.


The general form is modelled on https://github.com/rockfabrik/deployment and
https://github.com/aszlig/vuizvui
