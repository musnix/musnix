# musnix

(Experimental) meta-module for realtime audio in NixOS.

### Usage:
Add the following to your `configuration.nix`:
```
  imports = 
    [ <existing imports>
      /path/to/musnix
    ];
    
  musnix.enable = true;
```

### Options:

`musnix.enable`
* Default value: `false`
    
`musnix.kernel.optimize`
* Default value: `false`
* **WARNING:** Enabling this option will rebuild your kernel.
* Description: If enabled, this option will configure the kernel to be preemptible, to use the deadline I/O scheduler, to use the High Precision Event Timer (HPET), and to disable CPU frequency scaling.

`musnix.ffado.enable`
* Default value: `false`
* Description: If enabled, use the Free FireWire Audio Drivers (FFADO).

`musnix.alsaSeq.enable`
* Default value: `true`
* Description: If enabled, load ALSA Sequencer kernel modules.  Currently, this only loads the `snd-seq` and `snd-rawmidi` modules.
