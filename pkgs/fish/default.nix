{
    pkgs ? import <nixpkgs> { },
    lib ? pkgs.lib,
    ...
}:

pkgs.stdenv.mkDerivation rec {
    pname = "fish-config";
    version = "1.0";

    src = builtins.path {
        path = ./.;
        name = pname;
    };

    installPhase = ''
              mkdir -p $out
        	  cp -r ${src}/* $out/
        	'';

    dontUnpack = true;
    dontBuild = true;
}
