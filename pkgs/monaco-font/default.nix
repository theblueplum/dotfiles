{
    pkgs ? import <nixpkgs> { system = builtins.currentSystem; },
    lib ? pkgs.lib,
    ...
}:

pkgs.stdenv.mkDerivation rec {
    pname = "monaco-font";
    version = "1.0";

    src = builtins.fetchurl {
        url = "https://github.com/taodongl/monaco.ttf/raw/refs/heads/master/monaco.ttf";
        sha256 = "sha256:09chm7js9qk80q47d1ybp5imhl0bwjp0kcwfk4i8hcsjbf0cwrvw";
    };

    dontUnpack = true;

    installPhase = ''
        mkdir -p $out/share/fonts/truetype
        cp $src $out/share/fonts/truetype/monaco.ttf
    '';

    meta = with lib; {
        desscription = "Monaco font";
        homepage = "https://github.com/taodongl/monaco.ttf";
        licensse = licenses.free;
        platforms = platforms.all;
    };
}
