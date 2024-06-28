final: prev:
let
  dts = prev.lib.fileset.toSource {
    root = ../dts;
    fileset = ../dts;
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
