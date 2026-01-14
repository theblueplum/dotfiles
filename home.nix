{
    pkgs,
    lib ? pkgs.lib,
    ...
}:

let
    mpkgs = import ./pkgs/default.nix { };
    inherit (mpkgs.config) neovim fish;

    env = import ./.env.nix { inherit pkgs; };

    home = /home/anton;
in
{
    imports = [ ];

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
        vscode
        godotPackages_4_5.godot

        neovim
        btop
        xclip
        tree
        xh
        babelfish
        hyperfine
        bat

        typst
        tinymist

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

    programs.tetrio-desktop = {
        enable = true;
        package = mpkgs.tetrio.desktop;

        plus = {
            enable = true;
            package = mpkgs.tetrio.plus;
            skin.package = mpkgs.tetrio.skins.simple-connected;
        };

        settings = {
            handling = {
                auto_repeat_rate = 0;
                delayed_auto_shift = 7;
                soft_drop_factor = 14;
            };
            audio = {
                scroll_adjust_volume = false;
                stereo = 60;

                music.preferences = {
                    kaze-no-sanpomichi = "-";
                    muscat-to-shiroi-osara = "-";
                    akindo = "+";
                    yoru-no-niji = "+";
                    burari-tokyo = "+";
                    fuyu-no-jinkoueisei = "+";
                    honemi-ni-shimiiru-karasukaze = "-";
                    "21seiki-no-hitobito" = "+";
                    haru-wo-machinagara = "++";
                    go-go-go-summer = "-";
                    sasurai-no-hitoritabi = "++";
                    wakana = "-";
                    zange-no-ma = "-";
                    asphalt = "-";
                    madobe-no-hidamari = "--";
                    sora-no-sakura = "-";
                    suiu = "-";
                    burning-heart = "+";
                    hayate-no-sei = "-";
                    ima-koso = "+";
                    chiheisen-wo-koete = "--";
                    moyase-toushi-yobisamase-tamashii = "-";
                    uchuu-5239 = "+";
                    ultra-super-heros = "-";
                };
            };
            visual = {
                board_bounciness = 20;
                background_opacity = 0;
            };
            multiplayer.notifications.suppress_while_playing = true;

            skip_login_screen = "by-url";
            advertisments.i_support_the_devs.i_cannot_play_with_ads.and_i_really_want_to.disable = true;

            devtools = true;
        };
    };

    programs.vesktop = import ./home/vesktop.nix;

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

    home.stateVersion = mpkgs.system.stateVersion;
}
