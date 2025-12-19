{
    config,
    pkgs,
    lib ? pkgs.lib,
    ...
}:

let
    concat = strings: builtins.concatStringsSep " " strings;
in
{
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
        modesetting.enable = true;

        open = true;

        nvidiaSettings = true;

        package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    home-manager.users.anton.xsession.profileExtra = concat [
        "${lib.getExe pkgs.xorg.xrandr}"
        "${concat [
            "--output DP-2"
            "--mode 1920x1080"
            "--pos 0x0"
            "--rate 144"
            "--primary"
        ]}"
        "${concat [
            "--output HDMI-0"
            "--mode 1920x1080"
            "--pos 1920x0"
            "--rate 144"
        ]}"
    ];
}
