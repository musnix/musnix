# this hair is here to appease my editor's pyflakes checks for undeclared names
appease_pyflakes = vars()
machine = appease_pyflakes['machine']
subtest = appease_pyflakes['subtest']
# end hair

rtcs_required = [
    "Not running as root",
    "User musnix is member of a group that has sufficient rtprio",
    "The scaling governor of all CPUs is set to performance",
    "Valid kernel configuration found",
    "High resolution timers are enabled",
    "is using a tickless kernel",
    "is using threaded IRQs",
    "Realtime priorities can be set",
    "Power management can be controlled from user space",
]

machine.start()
machine.wait_for_unit("multi-user.target")

with subtest("preemptive-kernel"):
    result = machine.succeed("uname -v")
    print(result)
    if not "PREEMPT RT" or not "PREEMPT_RT" in result:
        raise Exception("Wrong OS")

with subtest("swappiness"):
    result = machine.succeed("cat /proc/sys/vm/swappiness")
    print(result)
    if not result.strip() == "10":
        raise Exception("Swappiness not set to 10")

with subtest("envvars"):
    for v, p in (
            ("CLAP_PATH", "clap"),
            ("DSSI_PATH", "dssi"),
            ("LADSPA_PATH", "ladspa"),
            ("LV2_PATH", "lv2"),
            ("LXVST_PATH", "lxvst"),
            ("VST3_PATH", "vst3"),
            ("VST_PATH", "vst"),
    ):
        print(machine.succeed(f"echo {v}"))
        result = machine.succeed(f'bash -c "echo ${v}"')
        print(result)
        expecteds = (
            f"/root/.nix-profile/lib/{p}",
            f"/run/current-system/sw/lib/{p}",
            f"/etc/profiles/per-user/root/lib/{p}",
            f"/root/.{p}"
        )
        for expected in expecteds:
            if not expected in result:
                raise Exception(f"{v} does not contain {expected}")

with subtest("alsa-seq"):
    result = machine.succeed("lsmod")
    print(result)
    if not "rawmidi" in result:
        raise Exception("Alsa rawmidi kernel module not loaded")

with subtest("rtcqs"):
    machine.succeed("useradd -m musnix")
    machine.succeed("usermod -a -G audio musnix")
    result = machine.succeed("su - musnix -c rtcqs")
    print(result)
    missed = []
    for line in rtcs_required:
        if not line in result:
            missed.append(line)
    if missed:
        raise Exception(missed)

with subtest("rtirq"):
    result = machine.succeed("systemctl status rtirq")
    print(result)
    if not "Setting IRQ high-priorities: start [timer]" in result:
        raise Exception("rtirq service set high priority to timer unsuccessful")

print("PASSED")
