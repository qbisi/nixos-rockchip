{
  fetchurl,
  fetchFromGitHub,
  linuxManualConfig,
  ...
}:
(linuxManualConfig rec {
  modDirVersion = "6.9.4";
  version = "${modDirVersion}-7ji";
  extraMeta.branch = "6.9";

  src = fetchurl {
        url = "mirror://kernel/linux/kernel/v6.x/linux-${modDirVersion}.tar.xz";
        hash = "sha256-JygA4NGn0Bp4vOlaOq9cgIFvUOsVxRfXAD5YNVdg7MI=";
  };

  kernelPatches = [
    {
        name = "7ji";
        patch = fetchurl {
            url = "https://github.com/7Ji-PKGBUILDs/linux-aarch64-7ji/releases/download/assets/sha256-0e1ad0c5f2812b819da5deb453b970ab62d4c1778928200989f4e50889387e1d-0001-rebase-local-changes-to-v6.9.patch.xz";
            hash = "sha256-DhrQxfKBK4Gdpd60U7lwq2LUwXeJKCAJifTlCIk4fh0=";
        };
    }
  ];

  # In case build machine not have aes support
  extraMakeFlags = ["KCFLAGS=-march=armv8-a+crypto"];

  configfile = ./config;
  allowImportFromDerivation = true;
})