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
# enable if https://github.com/musnix/musnix/pull/174 is merged
#    "Power management can be controlled from user space",
]

machine.start()
machine.wait_for_unit("multi-user.target")

with subtest("preemptive-kernel"):
    result = machine.succeed("uname -v")
    print(result)
    if not "PREEMPT RT" or not "PREEMPT_RT" in result:
        raise Exception("Wrong OS")

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
        raise ValueError(missed)

print("PASSED")
