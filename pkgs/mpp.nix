{lib, stdenv, cmake , fetchFromGitHub}:
stdenv.mkDerivation {
  pname = "mpp";
  version = "1.0.6";

  src =  fetchFromGitHub {
    owner = "rockchip-linux";
    repo = "mpp";
    rev = "1.0.6";
    hash = "sha256-rKVj+ZVvjn4KQfJBBT9DgcaraL8IsONuojwvj3Q4f8g=";
  };

  nativeBuildInputs = [ cmake ];

  configurePhase = ''
    cmake -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$out
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