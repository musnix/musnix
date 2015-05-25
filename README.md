# musnix

Real-time audio in NixOS

## About

**musnix** provides a set of simple, high-level configuration options for doing real-time audio work in [NixOS](https://nixos.org/), including optimizing the kernel, applying the [`CONFIG_PREEMPT_RT`](https://rt.wiki.kernel.org/index.php/Main_Page) patch to it, and adjusting various low-level system settings.

## Usage
Add the following to your `configuration.nix`:
```
  imports = 
    [ <existing imports>
      /path/to/musnix
    ];
    
  musnix.enable = true;

  user.extraUsers.<username>.extraGroups = [ "audio" ];

```

## Base Options

`musnix.enable`
* **Description:** Enable musnix, a module for real-time audio.
* **Default value:** `false`
* **NOTE:** This option must be set to `true` to use other musnix base options.
* **Details:** If enabled, this option will do the following:

  * Activate the `performance` CPU frequency scaling governor.

  * Set `vm.swappiness` to 10.

  * Set the following udev rules:
    ```
    KERNEL=="rtc0", GROUP="audio"
    KERNEL=="hpet", GROUP="audio"
    ```

  * Set the `max_user_freq` of `/sys/class/rtc/rtc0` to 2048.

  * Set the `max-user-freq` of `/proc/sys/dev/hpet` to 2048.

  * Set the following PAM limits:
    ```
    @audio  -       memlock unlimited
    @audio  -       rtprio  99
    @audio  soft    nofile  99999
    @audio  hard    nofile  99999
    ```
  
  * Set the following environment variables to default install locations in NixOS:
    * `VST_PATH` 
    * `LVST_PATH` 
    * `LADSPA_PATH`
    * `LV2_PATH`
    * `DSSI_PATH`

  * Allow users to install plugins in the following directories:
    * `~/.vst`
    * `~/.lvst`
    * `~/.ladspa`
    * `~/.lv2`
    * `~/.dssi`

`musnix.alsaSeq.enable`
* **Description:** If enabled, load ALSA Sequencer kernel modules.  Currently, this only loads the `snd_seq` and `snd_rawmidi` modules.
* **Default value:** `true`

`musnix.ffado.enable`
* **Description:** If enabled, use the Free FireWire Audio Drivers (FFADO).
* **Default value:** `false`

`musnix.soundcardPciId`
* **Description:** The PCI ID of the primary soundcard. Used to set the PCI latency timer.

  To find the PCI ID of your soundcard:
  ```
  lspci | grep -i audio
  ```
* **Default value:** `""`
* **Example value:** `"00:1b.0"`

## Kernel Options

**NOTE**: The following kernel options can be used without setting `musnix.enable = true;`

`musnix.kernel.optimize`
* **NOTE:** Enabling this option will rebuild your kernel.
* **Description:** If enabled, this option will configure the kernel to be preemptible, to use the deadline I/O scheduler, and to use the High Precision Event Timer (HPET).
* **Default value:** `false`

`musnix.kernel.realtime`
* **NOTE:** Enabling this option will rebuild your kernel.
* **Description:** If enabled, this option will apply the [`CONFIG_PREEMPT_RT`](https://rt.wiki.kernel.org/index.php/Main_Page) patch to the kernel.
* **Default value:** `false`

`musnix.kernel.latencytop`
* **NOTE:** Enabling this option will rebuild your kernel.
* **NOTE:** This option is only intended to be used for diagnostic purposes, and may cause other issues.
* **Description:** If enabled, this option will configure the kernel to use a latency tracking infrastructure that is used by the "latencytop" userspace tool.
* **Default value:** `false`

## rtirq Options

**NOTES**: 
* The following rtirq options can be used without setting `musnix.enable = true;`
* `musnix.kernel.realtime` must be set to `true` to use these options.

**musnix** can also install and run the [rtirq](http://wiki.linuxaudio.org/wiki/system_configuration#rtirq) script as a systemd service.

To see a list of options for using this feature, use the following command:

  `nixos-option musnix.rtirq`

To see a description of one of the listed options (in this case `enable`):

  `nixos-option musnix.rtirq.enable`

## Other Options

`musnix.das_watchdog.enable`
* **Description:** If enabled, start the [das_watchdog](https://github.com/kmatheussen/das_watchdog) service.  This service will ensure that a realtime process won't hang the machine.
* **Default value:** `true` if `musnix.kernel.realtime.enable = true`, otherwise `false`

## More Information
* http://wiki.linuxaudio.org/wiki/system_configuration
* http://wiki.linuxaudio.org/wiki/system_configuration#rtirq
* http://subversion.ffado.org/wiki/IrqPriorities
* https://wiki.archlinux.org/index.php/Pro_Audio
* https://nixos.org/wiki/Audio_HOWTO
