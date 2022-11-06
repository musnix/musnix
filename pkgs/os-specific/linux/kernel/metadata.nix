{
  kernels."5.4" = {
    branch = "5.4";
    kversion = "5.4.84";
    pversion = "rt47";
    sha256 = "058mhczv6whjwxn7jjh1c6n5zrqjdnvbl2mp7jkfrg6frpvgr189";
  };
  patches."5.4" = {
    branch = "5.4";
    kversion = "5.4.84";
    pversion = "rt47";
    sha256 = "0nccxf9l9ycvb782f48zrbl59vi674qq7yjyaks97440pgyd1jg0";
  };
  kernels."5.6" = {
    branch = "5.6";
    kversion = "5.6.19";
    pversion = "rt12";
    sha256 = "1s0yc1138sglbm4vyizl4r7hnc1l7nykdjp4063ad67yayr2ylv2";
  };
  patches."5.6" = {
    branch = "5.6";
    kversion = "5.6.19";
    pversion = "rt12";
    sha256 = "0ia8rx0615x0z2s4ppw1244crg7c5ak07c9n3wbnz7y8bk8hyxws";
  };
  kernels."5.9" = {
    branch = "5.9";
    kversion = "5.9.1";
    pversion = "rt20";
    sha256 = "0dn0xz81pphca5dkg6zh8c78p05f63rrr5ihqqsmhc4n73li2jms";
  };
  patches."5.9" = {
    branch = "5.9";
    kversion = "5.9.1";
    pversion = "rt20";
    sha256 = "0ma3mv475qgg0dri4928gi6z00d7s59pdwj0d6dh0mfzs2xddnyv";
  };
  kernels."5.15" = {
    branch = "5.15";
    kversion = "5.15.76";
    pversion = "rt53";
    sha256 = "sha256-kAegIMQZ42JbmA42G+CfcOvZnhVsy2YSmpgUg9Bl1X8=";
  };
  patches."5.15" = {
    branch = "5.15";
    kversion = "5.15.76";
    pversion = "rt53";
    url = "https://cdn.kernel.org/pub/linux/kernel/projects/rt/5.15/older/patch-5.15.76-rt53.patch.gz";
    sha256 = "sha256-b1PMCwfN0CERH4wXnAZNU86zmwEllAz1+IO1lgYs4Uc=";
  };
  kernels."5.16" = {
    branch = "5.16";
    kversion = "5.16.2";
    pversion = "rt19";
    sha256 = "sha256-Cf6DOk1jBDJ7vgDnWteiWHGI0fQGsyZf7RGg+MVmO0Q=";
  };
  patches."5.16" = {
    branch = "5.16";
    kversion = "5.16.2";
    pversion = "rt19";
    sha256 = "sha256-oy8nsxejTM5aqD7RIJvJTYB8GhfYv9AOPY+vlCuI2n8=";
  };
  kernels."5.17" = {
    branch = "5.17";
    kversion = "5.17.1";
    pversion = "rt17";
    sha256 = "sha256-fNXF1DKiX0UGCGjOaoV4iQ5VAVii93nEoggEtVHoTCQ";
  };
  patches."5.17" = {
    branch = "5.17";
    kversion = "5.17.1";
    pversion = "rt17";
    sha256 = "sha256-jPTVHQHu6Lv5R5nwVp9GDJJBpB0dl6TPs4ZEaLMFGDE=";
  };
  kernels."5.19" = {
    branch = "5.19";
    kversion = "5.19.0";
    pversion = "rt10";
    sha256 = "sha256-/yQMV5ue4a/8MYkX3gc5T8HDu0nawl7BKHNwwuFQBag=";
  };
  patches."5.19" = {
    branch = "5.19";
    kversion = "5.19.0";
    pversion = "rt10";
    url = "https://cdn.kernel.org/pub/linux/kernel/projects/rt/5.19/patch-5.19-rt10.patch.gz";
    sha256 = "sha256-OTYmKTWSEUdEZPxWTUbAws/akQ6LlPWCKatq9KKPJaI=";
  };
}
