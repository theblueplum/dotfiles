{
    pkgs ? import <nixpkgs> { },
    fetchzip ? pkgs.fetchzip,
	withTetrioPlus ? false,
	tetrio-plus ? pkgs.tetrio-plus,
    ...
}:

let
    tetrio-desktop =
        let
            version = "10";
        in
        {
            inherit version;
            src = fetchzip {
                url = "https://tetr.io/about/desktop/builds/${version}/TETR.IO%20Setup.deb";
                hash = "sha256-2FtFCajNEj7O8DGangDecs2yeKbufYLx1aZb3ShnYvw=";
                nativeBuildInputs = with pkgs; [ dpkg ];
            };
        };

in

(pkgs.tetrio-desktop.overrideAttrs {
    version = tetrio-desktop.version;
    src = tetrio-desktop.src;
}).override {
	inherit withTetrioPlus tetrio-plus;
}
