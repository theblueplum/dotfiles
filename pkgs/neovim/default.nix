{
    pkg ? import <nixpkg>,
    lib ? pkg.lib,
    ...
}:

pkg.stdenv.mkDerivation rec {
    pname = "neovim-config";
    version = "1.0";

    src = builtins.path {
        path = ./.;
        name = "neovim-config";
    };

    installPhase = ''
        mkdir -p $out
        cp -r ${src}/* $out/
    '';

    dontUnpack = true;
    dontBuild = true;
}
