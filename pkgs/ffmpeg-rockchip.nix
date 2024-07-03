{ ffmpeg_6-full
, fetchFromGitHub
, lib
, fetchpatch2
, gmp
, amf-headers
, libiec61883
, libavc1394
, mpp
, librga-multi
}:

let
  version = "6.1";
in

(ffmpeg_6-full.override {
  inherit version; # Important! This sets the ABI.
  source = fetchFromGitHub {
    owner = "nyanmisaka";
    repo = "ffmpeg-rockchip";
    rev = "9efe5bcff082d6538702d01c9b7126f40da27361";
    hash = "sha256-yoEMbWbtG24WKLM8azzxZWhPDu5lXVtJMgvLyLBkTA0=";
  };
  withVulkan = false;
}).overrideAttrs (old: {
  pname = "ffmpeg-rockchip";

  patches = old.patches ++ [
    (fetchpatch2
      {
        name = "add-av_stream_get_first_dts-for-chromium";
        url = "https://raw.githubusercontent.com/7Ji-PKGBUILDs/ffmpeg-mpp-git/b32080c1992313df0e543440c6d70d351120fa36/add-av_stream_get_first_dts-for-chromium.patch";
        hash = "sha256-DbH6ieJwDwTjKOdQ04xvRcSLeeLP2Z2qEmqeo8HsPr4=";
      }
    )
    (fetchpatch2
      {
        name = "flvdec-handle-unknown";
        url = "https://raw.githubusercontent.com/obsproject/obs-deps/faa110d336922831b5cdc261a9559e3a2dd5db3c/deps.ffmpeg/patches/FFmpeg/0001-flvdec-handle-unknown.patch";
        hash = "sha256-WlGF9Uy89GcnY8zmh9G23bZiVJtpY32oJiec5Hl/V+8=";
      }
    )
    (fetchpatch2
      {
        name = "libaomenc-presets";
        url = "https://raw.githubusercontent.com/obsproject/obs-deps/faa110d336922831b5cdc261a9559e3a2dd5db3c/deps.ffmpeg/patches/FFmpeg/0002-libaomenc-presets.patch";
        hash = "sha256-1fFBDvsx/jHo6QXsPxDMt4Qd1VlMs1kcOyBedyMv0YM=";
      }
    )
  ];

  configureFlags = old.configureFlags ++ [
    "--extra-version=rockchip"
    "--enable-amf"
    "--enable-gmp"
    "--enable-libiec61883"
    "--enable-rkmpp"
    "--enable-rkrga"
  ];

  buildInputs = old.buildInputs ++
    [
      gmp
      amf-headers
      libiec61883
      libavc1394
      mpp
      librga-multi
    ];

  meta = with lib; {
    homepage = "https://github.com/nyanmisaka/ffmpeg-rockchip";
    license = licenses.gpl3;
  };
})
