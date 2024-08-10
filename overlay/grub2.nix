final: prev:
{
  grub2 = prev.grub2.overrideAttrs (new: old: {
    patches = old.patches ++ [
      ./grub2-smbios-tolowercase.patch
    ];
  });
}
