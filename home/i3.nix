{
    pkgs,
    lib ? pkgs.lib,
    ...
}:

let
    mod = "Mod4";

    wallpaper = pkgs.callPackage ../pkgs/wallpaper/default.nix { };

    env = import /etc/nixos/.env.nix { inherit pkgs; };
in
{
    enable = true;

    config = {
        modifier = mod;

        fonts = {
            names = [ "Monaco" ];
            size = 8.0;
        };

        keybindings = lib.mkOptionDefault {
            "${mod}+q" = "kill";
            "${mod}+n" = "exec \"${
                lib.concatStringsSep " " [
                    "${lib.getExe pkgs.rofi}"
                    "-show combi"
                    "-modes combi"
                    "-combi-modes drun,run"
                    "-combi-display-format {text}"
                ]
            }\"";
            "${mod}+Return" = "exec ${lib.getExe pkgs.kitty}";

            "${mod}+Left" = "focus left";
            "${mod}+Right" = "focus right";
            "${mod}+Up" = "focus up";
            "${mod}+Down" = "focus down";

            "${mod}+Shift+Left" = "move left";
            "${mod}+Shift+Right" = "move right";
            "${mod}+Shift+Up" = "move up";
            "${mod}+Shift+Down" = "move down";

            "${mod}+Ctrl+Left" = "move workspace to output left";
            "${mod}+Ctrl+Right" = "move workspace to output right";

            "Print" = "exec ${lib.getExe pkgs.flameshot} gui";
        };
    };

    extraConfig =
        let
            background = lib.concatStringsSep " " [
                "exec --no-startup-id"
                "${lib.concatStringsSep " " [
                    "${lib.getExe pkgs.xwinwrap}"
                    "-g 3820x1080"
                    "-s"
                    "-b"
                    "-ni"
                    "-sp"
                    "-ov"
                    "-nf"
                ]}"
                "--"
                "${lib.concatStringsSep " " [
                    "${lib.getExe pkgs.mpv}"
                    "${wallpaper}/wallpaper.mov"
                    "-wid WID"
                    "--loop"
                    "--no-audio"
                    "--no-osc"
                    "--no-input-default-bindings"
                    "--no-input-cursor"
                    "--gpu-api=vulkan"
                    "--vo=gpu-next"
                    "--framedrop=vo"
                    "--profile=low-latency"
                    "--hwdec=auto"
                ]}"
            ];
            displays =
                if (env ? displays) then
                    lib.concatStringsSep "\n" [
                        "workspace 1 output ${env.displays.primary}"
                        (if (env.displays ? secondary) then "workspace 2 output ${env.displays.secondary}" else "")
                        "exec i3-msg focus output ${env.displays.primary}"
                    ]
                else
                    "";
        in
        lib.concatStringsSep "\n" [
            background
            displays
        ];
}
