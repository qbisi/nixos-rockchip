final: prev:
{
  makeLinuxHeaders = args: (prev.makeLinuxHeaders args).overrideAttrs (
    final: prev: {
      installPhase = prev.installPhase + ''
        cp -r include/dt-bindings $out/include
      '';
    }
  );
}
