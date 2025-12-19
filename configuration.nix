{
    config,
    pkgs,
    lib,
    ...
}:

let
    stateVersion = "25.05";
    env = import ./.env.nix { inherit pkgs; };
in
{
    imports = [
        # Include the results of the hardware scan.
        ./hardware-configuration.nix
        (import (./. + "/${env.hostname}.nix"))
        (
            let
                home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-${stateVersion}.tar.gz";
            in
            import "${home-manager}/nixos"
        )
    ];

    nixpkgs.config.allowUnfree = true;
    nixpkgs.overlays = [
        (import "${fetchTarball "https://github.com/nix-community/fenix/archive/main.tar.gz"}/overlay.nix")
    ];

    environment.systemPackages = with pkgs; [
        chromium

        libsecret
        gnome-keyring
        adwaita-icon-theme
        gtk3

        vim
        git
        xh
        jq
        fzf
        ripgrep

        (fenix.stable.withComponents [
            "rustc"
            "cargo"
            "clippy"
            "rust-src"
            "rustfmt"
            "rust-analyzer"
        ])
        nodejs-slim_latest
        pnpm
        nixd
        nixfmt-rfc-style
        clang
        llvmPackages.bintools
        stylua
    ];

    fonts.packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-emoji
        jetbrains-mono
        nerd-fonts.symbols-only
        inter
        times-newer-roman
        (import ./pkgs/monaco-font/default.nix { inherit pkgs; })
    ];

    fonts.fontconfig = {
        enable = true;
        defaultFonts = {
            monospace = [
                "JetBrains Mono"
                "Symbols Nerd Font"
                "Liberation Mono"
                "Monaco"
            ];
            sansSerif = [
                "Inter"
                "Noto Sans"
            ];
            serif = [ "Times Newer Roman" ];
        };
    };

    services = {
        xserver = {
            enable = true;

            windowManager.i3 = {
                enable = true;

                extraPackages = with pkgs; [
                    rofi
                    i3status
                ];
            };

            displayManager.startx.enable = true;
            tty = 7;

            # Configure keymap in X11
            xkb = {
                layout = "us";
                variant = "";
                options = "caps:super";
            };

            excludePackages = with pkgs; [ xterm ];
        };
        greetd = {
            enable = true;
            vt = config.services.xserver.tty;
            restart = false;
            settings = {
                default_session = {
                    command = lib.concatStringsSep " " [
                        "${lib.getExe pkgs.greetd.tuigreet}"
                        "--remember"
                        "--asterisks"
                        "--time"
                    ];
                    user = "greeter";
                };
            };
        };
    };

    programs.chromium = import ./home/chromium.nix;

    programs.fish.enable = true;
    programs.bash.interactiveShellInit = ''
        		if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]] then
        			shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        			exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        		fi
    '';

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.anton = {
        isNormalUser = true;
        description = "anton";
        shell = pkgs.bash;
        extraGroups = [
            "networkmanager"
            "wheel"
        ];
    };

    home-manager.useUserPackages = true;
    home-manager.useGlobalPkgs = true;
    home-manager.users.anton = import ./home.nix;

    # programs.home-manager.enable = true;
    programs.dconf.enable = true;
    qt = {
        enable = true;
        platformTheme = "gnome";
        style = "adwaita-dark";
    };

    hardware.graphics.enable = true;

    hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;

        settings = {
            General = {
                Experimental = true;
                FastConnectable = true;
            };
            Policy.AutoEnable = true;
        };
    };

    programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
    };

    services.gnome.gnome-keyring.enable = true;

    # Bootloader.
    boot.loader.systemd-boot = {
        enable = true;
        configurationLimit = 10;
    };
    boot.loader.efi.canTouchEfiVariables = true;

    boot.kernelParams = [ "console=tty1" ];

    boot.kernelPackages = pkgs.linuxPackages_latest;

    networking.hostName = env.hostname;
    networking.firewall.enable = false;

    networking.networkmanager.enable = true;

    time.timeZone = "Europe/Stockholm";

    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
        LC_ADDRESS = "sv_SE.UTF-8";
        LC_IDENTIFICATION = "sv_SE.UTF-8";
        LC_MEASUREMENT = "sv_SE.UTF-8";
        LC_MONETARY = "sv_SE.UTF-8";
        LC_NAME = "sv_SE.UTF-8";
        LC_NUMERIC = "sv_SE.UTF-8";
        LC_PAPER = "sv_SE.UTF-8";
        LC_TELEPHONE = "sv_SE.UTF-8";
        LC_TIME = "sv_SE.UTF-8";
    };

    nix.settings.extra-experimental-features = [ "nix-command" ];

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = stateVersion; # Did you read the comment?
}
