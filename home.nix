{
    pkgs,
    lib ? pkgs.lib,
    ...
}:

let
    neovim = pkgs.callPackage ./pkgs/neovim/default.nix { };
    fish = pkgs.callPackage ./pkgs/fish/default.nix { };

    env = import ./.env.nix;

    home = /home/anton;
in
{
    home.username = lib.mkDefault "anton";
    home.homeDirectory = lib.mkDefault home;

    home.packages = with pkgs; [
        element-desktop
        spotify
        kitty
        vesktop
        flameshot
        krita
        davinci-resolve

        btop
        neovim
        xclip
        tree
        xh
        babelfish
        hyperfine

        # required by spotify
        ffmpeg_4
    ];

    home.pointerCursor = {
        gtk.enable = true;
        x11.enable = true;
        name = "Posy_Cursor_Black";
        size = 32;
        package = pkgs.posy-cursors;
    };

    xsession = {
        enable = true;
        windowManager.i3 = import ./home/i3.nix { inherit pkgs; };
    };

    programs.btop.enable = true;
    programs.fastfetch.enable = true;

    programs.kitty = import ./home/kitty.nix { inherit pkgs; };

    programs.fish = {
        enable = true;
        shellInit = ''
            set fish_function_path $fish_function_path ${fish}/functions
        '';
        interactiveShellInit = ''
            source ${fish}/config.fish
        '';
    };

    # Fix Fish command not found issues
    programs.command-not-found.enable = false;

    programs.neovim = {
        enable = true;
        defaultEditor = true;
        extraConfig = ''
            			set runtimepath+=${neovim}
            			source ${neovim}/init.lua
        '';
    };

    programs.rofi = {
        enable = true;
        theme = "gruvbox-dark-soft";
        font = "Monaco 12";
    };

    programs.git = {
        enable = true;

        signing =
            if (env.git or { }) ? signingKey then
                {
                    key = env.git.signingKey;
                    signByDefault = true;
                }
            else
                { signByDefault = false; };

        extraConfig = {
            user.name = "Anton";
            user.email = "aligator.h0spital.e@gmail.com";

            color = {
                status = "always";
                branch = "always";
                diff = "always";
                interactive = "always";
            };

            init.defaultBranch = "main";
            push.autoSetupRemote = true;

            "filter \"lfs\"" = {
                clean = "git-lfs clean -- %f";
                smudge = "git-lfs smudge -- %f";
                process = "git-lfs filter-process";

                required = true;
            };

            "url \"ssh://git@github.com/\"".insteadOf = "gh:";
            "url \"ssh://git@github.com/antonw51\"".insteadOf = "gh:me";

            "url \"ssh://git@ip.louiscreates.com/\"".insteadOf = "tea:";
            "url \"ssh://git@ip.louiscreates.com/antonw51\"".insteadOf = "tea:me";

            alias.ref = "show -s --pretty = reference";
        };
    };

    services.gpg-agent = {
        enable = true;
        enableSshSupport = true;
        enableFishIntegration = true;

        pinentry.package = pkgs.pinentry-curses;
    };

    dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

    gtk = {
        enable = true;
        theme = {
            name = "Adwaita-dark";
            package = pkgs.gnome-themes-extra;
        };
    };

    home.sessionVariables = {
        NIXPKGS_ALLOW_UNFREE = 1;
    };

    home.stateVersion = (pkgs.callPackage <nixos-config> { }).system.stateVersion;
}
