final: prev: {
  lib = prev.lib.extend (
    self:
    super:
    {
      genAttrs' =
        names:
        k:
        v:
        super.listToAttrs (map (n: super.nameValuePair (k n) (v n)) names);

      listNixfile = path: with builtins; filter 
        (name: match "(.+)\\.nix" name != null) 
        (attrNames (readDir path));

      listNixname = path: with builtins; map
        (file: head (match "(.+)\\.nix" file))
        (self.listNixfile path);
    }
  );
}
