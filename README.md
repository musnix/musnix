musnix
======

(Highly experimental) meta-module for realtime audio in NixOS.

### Usage:
1. Add the following to your ```configuration.nix```:
```
  imports = 
    [ <existing imports>
      /path/to/musnix
    ];
    
  musnix.enable = true;
```

### Options:

``musnix.enable``
* Default value: ``false``
    
``musnix.kernel.preempt.enable``
* Default value: ``true``
    
``musnix.ffado.enable``
* Default value: ``false``

``musnix.alsaSeq.enable``
* Default value: ``true``

-----
Inspiration:
* https://github.com/rockfabrik/deployment
* https://github.com/aszlig/vuizvui
