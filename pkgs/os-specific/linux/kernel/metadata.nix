{
  kernels."5.4" = {
    branch = "5.4";
    kversion = "5.4.221";
    pversion = "rt79";
    sha256 = "sha256-J7N/wf7XtNzd9aCjcw+r8lGXwLoTrOaESBqlREZJ3wo=";
  };
  patches."5.4" = {
    branch = "5.4";
    kversion = "5.4.221";
    pversion = "rt79";
    sha256 = "sha256-viuxek8lAYirHIYhe7KX5z1uUTLNVMbvQMaGGkiein0=";
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
  kernels."6.0" = {
    branch = "6.0";
    kversion = "6.0.5";
    pversion = "rt14";
    sha256 = "sha256-YTMu8itTxQwQ+qv7lliWp9GtTzOB8PiWQ8gg8opgQY4=";
  };
  patches."6.0" = {
    branch = "6.0";
    kversion = "6.0.5";
    pversion = "rt14";
    sha256 = "sha256-BkTq7aIWBfcd3Pmeq5cOPtoVVQYtQIQJSKlWvsmkcWc=";
  };
}
