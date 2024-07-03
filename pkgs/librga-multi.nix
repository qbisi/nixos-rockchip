{ lib, fetchurl, fetchpatch2, stdenv, meson, ninja, fetchFromGitHub }:
let
  rga_commit = "d7a0a485ed6c201f882c20b3a8881e801f131385";
in
stdenv.mkDerivation {
  pname = "librga-multi";
  version = "1.10.0";

  src = fetchurl {
    url = "https://github.com/JeffyCN/mirrors/archive/${rga_commit}.tar.gz";
    hash = "sha256-WjNxVfLVW8axEvNmIJ0+OCeboG4LiGWwJy6fW5Mkm5Y=";
  };

  # In Nixpkgs, meson comes with a setup hook that overrides the configure, check, and install phases.
  # https://nixos.org/manual/nixpkgs/stable/#meson
  nativeBuildInputs = [ meson ninja ];

  patches = [
    (fetchpatch2
      {
        name = "normalrga-cpp-add-10b-compact-endian-mode.patch";
        url = "https://raw.githubusercontent.com/7Ji-PKGBUILDs/librga-multi/615fb730b7656ad4a0cb169bfa9a52336820f99f/normalrga-cpp-add-10b-compact-endian-mode.patch";
        hash = "sha256-JvKZCBjWtkEsfx1Xsnysw9PjC3/60f1ni10tmR8fTHQ=";
      }
    )
  ];

  meta = with lib; {
    description = "Rockchip RGA User-Space Library";
    license = licenses.asl20;
  };

}
