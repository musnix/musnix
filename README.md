# musnix

[![Check](https://github.com/musnix/musnix/actions/workflows/check.yml/badge.svg)](https://github.com/musnix/musnix/actions/workflows/check.yml)

Real-time audio in NixOS

## About

**musnix** provides a set of simple, high-level configuration options for doing real-time audio work in [NixOS](https://nixos.org/), including optimizing the kernel, applying the [`CONFIG_PREEMPT_RT`](https://archive.kernel.org/oldwiki/rt.wiki.kernel.org/index.php/CONFIG_PREEMPT_RT_Patch.html) patch to it, and adjusting various low-level system settings.

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
As an alternative to the above approaches, you can also add musnix as a flake:

```nix
{
  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs/nixos-unstable"; };
    musnix  = { url = "github:musnix/musnix"; };
  };
  outputs = inputs: rec {
    nixosConfigurations = {
      example-config = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules =
          [ # ...
            inputs.musnix.nixosModules.musnix
            ./configuration.nix
          ];
        specialArgs = { inherit inputs; };
      };
    };
  };
# ...
```

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
    DEVPATH=="/devices/virtual/misc/cpu_dma_latency", OWNER="root", GROUP="audio", MODE="0660"
    ```

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

`musnix.rtcqs.enable`
* **Description:** If enabled, install the [rtcqs command-line utulity](https://wiki.linuxaudio.org/wiki/system_configuration#rtcqs), which analyzes the system and makes suggestions about what to change to make it more audio-friendly.
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
* **NOTE:** If you have a USB sound card, this option is not useful.

## Kernel Options

**NOTE**: The following kernel options can be used without setting `musnix.enable = true;`

`musnix.kernel.realtime`
* **NOTE:** Enabling this option will rebuild your kernel.
* **Description:** If enabled, this option will enable [`CONFIG_PREEMPT_RT`](https://wiki.linuxfoundation.org/realtime/preempt_rt_versions) on the kernel.
  * For kernels **6.12 and later**, `PREEMPT_RT` is available natively in the mainline kernel — no external patch is required. Set `musnix.kernel.packages` to any mainline kernel >= 6.12 and musnix will automatically apply the required configuration.
  * For kernels **older than 6.12**, set `musnix.kernel.packages` to one of the RT-patched packages provided by the musnix overlay (see below).
* **Type:** `boolean`
* **Default value:** `false`

`musnix.kernel.packages`
* **Description:** This option allows you to select the kernel used by musnix.
* **Type:** `package`
* **Default value:** `pkgs.linuxPackages`

  **Mainline kernels 6.12+ (recommended)** — musnix will automatically enable
  `PREEMPT_RT` via kernel configuration overrides; no patched package is needed:
  ```nix
  musnix.kernel.packages = pkgs.linuxPackages;        # default NixOS kernel (if >= 6.12)
  musnix.kernel.packages = pkgs.linuxPackages_6_12;   # specific LTS version
  musnix.kernel.packages = pkgs.linuxPackages_latest; # latest mainline
  ```

  **Pre-6.12 kernels** — use an RT-patched package from the musnix overlay:
  * `pkgs.linuxPackages_6_1_rt`
  * `pkgs.linuxPackages_6_6_rt`
  * `pkgs.linuxPackages_6_8_rt`
  * `pkgs.linuxPackages_6_9_rt`
  * `pkgs.linuxPackages_6_11_rt`

  or the convenience aliases:
  * `pkgs.linuxPackages_rt` (currently `pkgs.linuxPackages_6_6_rt`)
  * `pkgs.linuxPackages_latest_rt` (currently `pkgs.linuxPackages_6_11_rt`)

  > **Note:** When a mainline kernel >= 6.12 is selected, musnix overrides it
  > with `EXPERT=y`, `PREEMPT_RT=y`, and unsets options that are mutually
  > exclusive with RT (`PREEMPT_VOLUNTARY`, `PREEMPT_FULL`, `RT_GROUP_SCHED`).
  > `ignoreConfigErrors = true` is set so that version-specific disappearing
  > symbols (e.g. i915 GVT, Rust assertions) do not break the build.
  
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
* **Default value:** `true` if `musnix.kernel.realtime = true`, otherwise `false`

## Communication

* **IRC:** `#musnix` on [libera.chat](https://libera.chat/)

## More Information
* http://wiki.linuxaudio.org/wiki/system_configuration
* http://wiki.linuxaudio.org/wiki/system_configuration#rtirq
* http://subversion.ffado.org/wiki/IrqPriorities
* https://wiki.archlinux.org/index.php/Pro_Audio
* https://nixos.org/wiki/Audio_HOWTO
