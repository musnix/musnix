# musnix

Real-time audio in NixOS

## About

**musnix** provides a set of simple, high-level configuration options for doing real-time audio work in [NixOS](https://nixos.org/), including optimizing the kernel, applying the [`CONFIG_PREEMPT_RT`](https://rt.wiki.kernel.org/index.php/Main_Page) patch to it, and adjusting various low-level system settings.

## Basic Usage
Clone this project.

Add the following to your `configuration.nix`:
```nix
{
  imports =
    [ # ...
      /path/to/musnix/clone
    ];

  musnix.enable = true;
  users.users.johndoe.extraGroups = [ "audio" ];
}
```

To update musnix, run `git pull`.

Later sections of this document contain information about the various configuration options.

### Using musnix as a channel
As an alternative to the above approach, you can instead add musnix as a channel:

```
sudo -i nix-channel --add https://github.com/musnix/musnix/archive/master.tar.gz musnix
sudo -i nix-channel --update musnix
```

Add `<musnix>` to `imports` in your `configuration.nix`:
```nix
{
  imports =
    [ # ...
      <musnix>
    ];

  musnix.enable = true;
  users.users.johndoe.extraGroups = [ "audio" ];
}
```

To update musnix, run:
```
sudo -i nix-channel --update musnix
```

### Using musnix as a flake
As an alternative to nix-channels or cloning the project you can instead use it as a flake in a pure system.

```nix
{
  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs/nixos-unstable"; };
    musnix = { url = "github:musnix/musnix"; };
  };
  outputs = inputs: rec {
    nixosConfigurations = {
      example-config = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ## Other modules will also be here
          inputs.musnix.nixosModules.musnix
          ./configuration.nix ## Configuration file from regular /etc/nixos config
        ];
        specialArgs = { inherit inputs; }; ## Inherit inputs to configuration.nix so you can call inputs.inputname
       };
      };
  }
```
The above code snippet is a full user-side flake.nix, and it properly adds the repo's git repo to your config and `inputs.musnix.nixosModules.musnix` automatically adds a musnix modules.

The flake.nix, from the repo, automatically gets "imported" (not an actual import but close enough in function for non-flake users) and it adds musnix packages and modules via adding `inputs.musnix.nixosModules.musnix` to the `modules`section.

## Base Options

`musnix.enable`
* **Description:** Enable musnix, a module for real-time audio.
* **Type:** `boolean`
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
    * `VST3_PATH`
    * `LXVST_PATH`
    * `LADSPA_PATH`
    * `LV2_PATH`
    * `DSSI_PATH`

  * Allow users to install plugins in the following directories:
    * `~/.vst`
    * `~/.vst3`
    * `~/.lxvst`
    * `~/.ladspa`
    * `~/.lv2`
    * `~/.dssi`

`musnix.alsaSeq.enable`
* **Description:** If enabled, load ALSA Sequencer kernel modules.  Currently, this only loads the `snd_seq` and `snd_rawmidi` modules.
* **Type:** `boolean`
* **Default value:** `true`

`musnix.ffado.enable`
* **Description:** If enabled, use the Free FireWire Audio Drivers (FFADO).
* **Type:** `boolean`
* **Default value:** `false`

`musnix.soundcardPciId`
* **Description:** The PCI ID of the primary soundcard. Used to set the PCI latency timer.

  To find the PCI ID of your soundcard:
  ```
  lspci | grep -i audio
  ```
* **Type:** `string`
* **Default value:** `""`
* **Example value:** `"00:1b.0"`

## Kernel Options

**NOTE**: The following kernel options can be used without setting `musnix.enable = true;`

`musnix.kernel.optimize`
* **NOTE:** Enabling this option will rebuild your kernel.
* **Description:** If enabled, this option will configure the kernel to be preemptible, to use the deadline I/O scheduler, and to use the High Precision Event Timer (HPET).
* **Type:** `boolean`
* **Default value:** `false`

`musnix.kernel.realtime`
* **NOTE:** Enabling this option will rebuild your kernel.
* **Description:** If enabled, this option will apply the [`CONFIG_PREEMPT_RT`](https://rt.wiki.kernel.org/index.php/Main_Page) patch to the kernel.
* **Type:** `boolean`
* **Default value:** `false`

`musnix.kernel.packages`
* **Description:** This option allows you to select the real-time kernel used by musnix.
* **Type:** `package`
* **Default value:** `pkgs.linuxPackages_5_4_rt, which is the major version that NixPkgs unstable currently uses.
* Available packages:
  * `pkgs.linuxPackages_3_18_rt`
  * `pkgs.linuxPackages_4_1_rt`
  * `pkgs.linuxPackages_4_4_rt`
  * `pkgs.linuxPackages_4_9_rt`
  * `pkgs.linuxPackages_4_11_rt`
  * `pkgs.linuxPackages_4_13_rt`
  * `pkgs.linuxPackages_4_14_rt`
  * `pkgs.linuxPackages_4_16_rt`
  * `pkgs.linuxPackages_4_18_rt`
  * `pkgs.linuxPackages_4_19_rt`
  * `pkgs.linuxPackages_5_0_rt`
  * `pkgs.linuxPackages_5_4_rt`
  * `pkgs.linuxPackages_5_6_rt`

  or:
  * `pkgs.linuxPackages_latest_rt` (currently `pkgs.linuxPackages_5_6_rt`)

`musnix.kernel.latencytop`
* **NOTE:** Enabling this option will rebuild your kernel.
* **NOTE:** This option is only intended to be used for diagnostic purposes, and may cause other issues.
* **Description:** If enabled, this option will configure the kernel to use a latency tracking infrastructure that is used by the "latencytop" userspace tool.
* **Type:** `boolean`
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
* **Type:** `boolean`
* **Default value:** `true` if `musnix.kernel.realtime.enable = true`, otherwise `false`

## Communication

* **IRC:** `#musnix` on [freenode](http://freenode.net/)

## More Information
* http://wiki.linuxaudio.org/wiki/system_configuration
* http://wiki.linuxaudio.org/wiki/system_configuration#rtirq
* http://subversion.ffado.org/wiki/IrqPriorities
* https://wiki.archlinux.org/index.php/Pro_Audio
* https://nixos.org/wiki/Audio_HOWTO
