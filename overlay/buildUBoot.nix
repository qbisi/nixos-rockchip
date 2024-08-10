final: prev:
{
  buildUBoot = { defconfig, extraConfig ? "", ... }@args: (prev.buildUBoot args).overrideAttrs {
    passAsFile = [ "extraConfig" ];
    prePatch = ''
      { echo "";cat $extraConfigPath; } >> ./configs/${defconfig}
    '';
    configurePhase = ''
      runHook preConfigure

      make ${defconfig}

      runHook postConfigure
    '';
  };
}
