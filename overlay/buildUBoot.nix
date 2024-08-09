final: prev:
let
  dts = prev.lib.fileset.toSource {
    root = ../dts/u-boot;
    fileset = ../dts/u-boot;
  };
  configfile = prev.lib.fileset.toSource {
    root = ../configs;
    fileset = ../configs;
  };
in
{
  buildUBoot = { defconfig, extraConfig ? "", ... }@args: (prev.buildUBoot args).overrideAttrs {
    passAsFile = [ "extraConfig" ];
    prePatch = ''
      install -m 666 ${dts}/* ./arch/arm/dts/
      install -m 666 ${dts}/* ./dts/upstream/src/arm64/rockchip/
      install -m 666 ${configfile}/* ./configs/
      { echo "";cat $extraConfigPath; } >> ./configs/${defconfig}
    '';
    configurePhase = ''
      runHook preConfigure

      make ${defconfig}

      runHook postConfigure
    '';
  };
}
