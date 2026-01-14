{
    pkgs ? import <nixpkgs> { config.allowUnfree = true; },
    config ? (import <nixpkgs/nixos> { }).config,
    fetchzip ? pkgs.fetchzip,
    ...
}:

let
    system = {
        stateVersion = config.system.stateVersion;
    };
    use = path: pkgs.callPackage (import path) { inherit pkgs; };
in
{
    inherit system;

    wallpaper = use ./wallpaper/default.nix;
    tetrio.desktop = use ./tetrio/default.nix;
    tetrio.plus =
        let
            repo = {
                owner = "UniQMG";
                name = "tetrio-plus";
                job = "11675178434";
                hash = "sha256-j3ACcnT64eMQtWYDGOE2oGXpnN5EUqk+lyV6ARBEtU8=";
            };
            src = fetchzip {
                url = "https://gitlab.com/${repo.owner}/${repo.name}/-/jobs/${repo.job}/artifacts/raw/app.asar.zip";
                hash = repo.hash;
            };
        in
        "${src}/app.asar";
    tetrio.skins = {
        simple-connected = use ./tetrio/skins/simple-connected.nix;
    };

    leveldb-cli = use ./leveldb/default.nix;

    config.neovim = use ./neovim/default.nix;
    config.fish = use ./fish/default.nix;

    font.monaco = use ./monaco-font/default.nix;

    home-manager = {
        module =
            let
                home-manager = fetchzip {
                    url = "https://github.com/nix-community/home-manager/archive/release-${system.stateVersion}.tar.gz";
                    hash = "sha256-WHkdBlw6oyxXIra/vQPYLtqY+3G8dUVZM8bEXk0t8x4=";
                };
            in
            import "${home-manager}/nixos";
        sharedModules = [ ./home-manager/initialFile.nix ./tetrio/module.nix ];
    };
}
