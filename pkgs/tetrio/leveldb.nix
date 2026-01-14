{
    pkgs ? import <nixpkgs> { },
    mpkgs ? import /etc/nixos/pkgs/default.nix { },
    origin ? "https://tetr.io",
    key ? "userConfig",
    value,
	...
}:

let
    src = ./.;
in
pkgs.stdenv.mkDerivation {
    pname = "tetrio-leveldb";
    version = "1";

    inherit src;

    nativeBuildInputs = [ mpkgs.leveldb-cli ];

    buildPhase = ''
                runHook preBuild

                ${pkgs.lib.getExe mpkgs.leveldb-cli} \
        			$out \
        			${pkgs.lib.escapeShellArg origin} \
        			${pkgs.lib.escapeShellArg key} \
        			${pkgs.lib.escapeShellArg (builtins.toJSON value)}

                runHook postBuild
    '';
}
