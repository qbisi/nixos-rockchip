final: prev:
{
  buildUBoot = { defconfig, extraConfig ? "", ... }@args: (prev.buildUBoot args).overrideAttrs (new: old: {
    passAsFile = [ "extraConfig" ];
    postPatch = ''
      { echo "";cat $extraConfigPath; } >> ./configs/${defconfig}
    '' + old.postPatch;
    configurePhase = ''
      runHook preConfigure

      make ${defconfig}

      runHook postConfigure
    '';
  });
}
