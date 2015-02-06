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
* **Description:** Enable musnix, a meta-module for realtime audio.
* **Default value:** `false`

`musnix.kernel.optimize`
* **WARNING:** Enabling this option will rebuild your kernel.
* **Description:** If enabled, this option will configure the kernel to be preemptible, use the deadline I/O scheduler and High Precision Event Timer (HPET), and disable CPU frequency scaling.
* **Default value:** `false`

`musnix.kernel.realtime`
* **WARNING:** Enabling this option will rebuild your kernel.
* **Description:** If enabled, this option will apply the realtime patch set to the kernel.
* **Default value:** `false`

`musnix.kernel.latencytop`
* **WARNING:** Enabling this option will rebuild your kernel.
* **Description:** If enabled, this option will configure the kernel to use a latency tracking infrastructure that is used by the "latencytop" userspace tool.
* **Default value:** `false`

`musnix.ffado.enable`
* **Description:** If enabled, use the Free FireWire Audio Drivers (FFADO).
* **Default value:** `false`

`musnix.alsaSeq.enable`
* **Description:** If enabled, load ALSA Sequencer kernel modules.  Currently, this only loads the `snd_seq` and `snd_rawmidi` modules.
* **Default value:** `true`

`musnix.soundcardPciId`
* **Description:** The PCI ID of the primary soundcard. Used to set the PCI latency timer.

  To find the PCI ID of your soundcard:
  ```
  lspci | grep -i audio
  ```
* **Default value:** `""`
* **Example value:** `"$00:1b.0"`
