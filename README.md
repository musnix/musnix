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
* **Default value:** `false`
    
`musnix.kernel.optimize`
* **WARNING:** Enabling this option will rebuild your kernel.
* **Description:** If enabled, this option will configure the kernel to be preemptible, to use the deadline I/O scheduler, to use the High Precision Event Timer (HPET), and to disable CPU frequency scaling.
* **Default value:** `false`

`musnix.ffado.enable`
* **Description:** If enabled, use the Free FireWire Audio Drivers (FFADO).
* **Default value:** `false`

`musnix.alsaSeq.enable`
* **Description:** If enabled, load ALSA Sequencer kernel modules.  Currently, this only loads the `snd-seq` and `snd-rawmidi` modules.
* **Default value:** `true`
