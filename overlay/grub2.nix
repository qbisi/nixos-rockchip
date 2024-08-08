final: prev:
{
  grub2 = prev.grub2.overrideAttrs (new: old: {
    patches = old.patches ++ [
      ./grub2_smbios_tolowercase.patch
    ];
  });
}
