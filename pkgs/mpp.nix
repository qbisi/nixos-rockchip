{lib, stdenv, fetchFromGitHub}:
stdenv.mkDerivation {
  pname = "mpp";
  version = "1.0.6";

  src =  fetchFromGitHub {
    owner = "rockchip-linux";
    repo = "mpp";
    rev = "1.0.6";
    hash = "sha256-tVu/3SF/+s+Z6ytKvuY+ZwqsXUlm40yOZ/O5ksNfUYc=";
  };

  configurePhase = ''
    cmake -S mpp -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$out/usr
  '';

  buildPhase = ''
    cmake --build build
  '';

  installPhase = ''
    cmake --install build
  '';

  meta = with lib; {
    description = "Media Process Platform (MPP)";
    homepage = "https://github.com/rockchip-linux/mpp";
    license = licenses.asl20;
  };

}