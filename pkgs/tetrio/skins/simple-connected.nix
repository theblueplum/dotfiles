{
    pkgs ? import <nixpkgs> { },
    ...
}:

let
    src = pkgs.fetchurl {
        url = "https://you.have.fail/tetrioplus/data/tpsefiles/skin/SpooKoArts/simple_connected.zip.tpse";
        hash = "sha256-dIrEpEV9Gy2iU6K6rMrNX4XFQEchkJqSmOuQwVF4EQQ=";
    };
in
pkgs.stdenv.mkDerivation {
    name = "simple-connected";
    version = "2022-06-26";
    inherit src;

	dontUnpack = true;
	dontBuild = true;

    installPhase = ''
        		runHook preInstall
        		cp ${src} $out
        		runHook postInstall
        	'';

	fixupPhase = ''
		runHook preFixup
		sed -i 's/\bskin\b/value/' $out
		runHook postFixup
	'';
}
