{
    config,
    lib,
    pkgs,
    ...
}:

let
    inherit (lib) mkOption mkIf types;
    inherit (types) either;

    clamp =
        x: min: max:
        if x < min then
            min
        else if x > max then
            max
        else
            x;

    leveldb = import ./leveldb.nix;

    cfg = config.programs.tetrio-desktop;
in
{
    options.programs.tetrio-desktop = {
        enable = lib.mkEnableOption "tetrio";
        package = lib.mkPackageOption pkgs "tetrio-desktop" { };

        plus = {
            enable = lib.mkEnableOption "tetrio-plus";
            package = lib.mkOption {
                type = types.path;
                description = "The package to use for TETR.IO PLUS";
                default = pkgs.tetrio-plus;
            };

            skin = mkOption {
                type = types.nullOr (
                    types.submodule {
                        options = {
                            package = mkOption {
                                type = types.package;
                                description = "The package to use for the skin";
                                example = "mpkgs.tetrio.skin.simple-connected";
                            };

                            nearest = mkOption {
                                type = types.bool;
                                description = "Force nearest-neighbor scaling";
                                default = false;
                            };
                        };
                    }
                );
                default = null;
                description = "In-game tetrimino skin";
            };

            hideOnStartup = lib.mkOption {
                type = types.bool;
                default = true;
                description = "Disable the TETR.IO PLUS configuration panel showing";
            };
        };
        settings = {
            handling =
                let
                    buffering = types.enum [
                        "off"
                        "hold"
                        "tap"
                    ];
                in
                {

                    auto_repeat_rate = mkOption {
                        type = types.number;
                        apply = x: clamp x 0 5;
                        description = "Automatic Repeat Rate: the speed at which tetrominoes move when holding down movement keys, measured in frames per movement.";
                        default = 2;
                    };
                    delayed_auto_shift = mkOption {
                        type = types.number;
                        apply = x: clamp x 1 20;
                        description = "Delayed Auto Shift: the time between the initial keypress and the start of its automatic repeat movement, measured in frames.";
                        default = 10;
                    };
                    das_cut_delay = mkOption {
                        type = types.number;
                        apply = x: clamp x 0 20;

                        description = "DAS Cut Delay (frames): if not 0, any ongoing DAS movement will pause for a set amount of time after dropping/rotating a piece, measured in frames.";
                        default = 1;
                    };
                    soft_drop_factor = mkOption {
                        type = types.number;
                        apply = x: clamp x 5 41;
                        description = "Soft Drop Factor: the factor with which soft drops change the gravity speed.";
                        default = 6;
                    };
                    prevent_hard_drops = mkOption {
                        type = types.bool;
                        description = "If enabled, when a piece locks on its own, the hard drop key becomes unavailable for a few frames. This prevents accidental hard drops.";
                        default = true;
                    };
                    direction_cancel_das = mkOption {
                        type = types.bool;
                        description = "If enabled, DAS charge is cancelled when you change directions.";
                        default = false;
                    };
                    soft_drop_over_movement = mkOption {
                        type = types.bool;
                        description = "If enabled, at very high speeds soft drop will always take precedence over horizontal movement, for a more consistent game feel.";
                        default = true;
                    };
                    rotation_buffering = mkOption {
                        type = buffering;
                        description = "When to buffer rotations for the next piece (\"hold\": only if you hold the key as the next piece spawns).";
                        default = "tap";
                    };
                    hold_buffering = mkOption {
                        type = buffering;
                        description = "When to buffer holding for the next piece (\"hold\": only if you hold the key as the next piece spawns).";
                        default = "tap";
                    };
                };
            audio =
                let
                    percentage = x: x / 100.0;
                in
                {
                    music = {
                        volume = mkOption {
                            type = types.number;
                            apply = x: percentage (clamp x 0 200);
                            description = "Volume (%) at which BGM and jingles play.";
                            default = 100;
                        };
                        reset_on_retry = mkOption {
                            type = types.bool;
                            apply = x: !x;
                            description = "If enabled, the background music will reset whenever you retry a game.";
                            default = false;
                        };
                        preferences = mkOption {
                            type =
                                with types;
                                attrsOf (enum [
                                    "off"
                                    "--"
                                    "-"
                                    ""
                                    "+"
                                    "++"
                                ]);
                            apply =
                                x:
                                pkgs.lib.mapAttrs (
                                    _: value:
                                    {
                                        "off" = "ban";
                                        "--" = "minmin";
                                        "-" = "min";
                                        "" = "base";
                                        "+" = "plus";
                                        "++" = "plusplus";
                                    }
                                    ."${value}"
                                ) x;
                            default = { };
                        };
                    };
                    sfx = {
                        volume = mkOption {
                            type = types.number;
                            apply = x: percentage (clamp x 0 200);
                            description = "Volume (%) at which sound effects play.";
                            default = 100;
                        };
                        next_pieces = mkOption {
                            type = types.bool;
                            description = "Whether to play a sound effect that signifies the next piece that'll come up.";
                            default = false;
                        };
                        other_players = mkOption {
                            type = types.bool;
                            description = "Whether to hear the sounds of other people playing in Multiplayer.";
                            default = true;
                        };
                        attacks = mkOption {
                            type = types.bool;
                            description = "Whether to hear the sounds of attacks going towards and from you.";
                            default = true;
                        };
                        speed_changes = mkOption {
                            type = types.bool;
                            description = "Whether to hear a sound when your Climb Speed changes in Quick Play.";
                            default = true;
                        };
                    };
                    scroll_adjust_volume = mkOption {
                        type = types.bool;
                        description = "Whether to allow adjusting the volume via scrolling in-game (or everywhere while holding ALT).";
                        default = true;
                    };
                    mute_unfocused = mkOption {
                        type = types.bool;
                        description = "If enabled, the background music will be muted when TETR.IO is minimized or tabbed away.";
                        default = true;
                    };
                    stereo = mkOption {
                        type = types.number;
                        apply = x: percentage (clamp x 0 100);
                        description = "Intensity (%) of stereo effects. 0% -> Centered; 100% -> Directional";
                        default = 50;
                    };
                    disable = mkOption {
                        type = types.bool;
                        description = "If enabled, no audio will ever play. This will speed up the game, with a rather obvious drawback.";
                        default = false;
                    };
                };
            visual =
                let
                    toFloat = x: if builtins.typeOf x == "str" then builtins.fromJSON x else x;
                    percentage =
                        x: min: max:
                        builtins.toString ((clamp (toFloat x) min max) / 100.0);
                in
                {
                    graphics = {
                        pipeline = mkOption {
                            type = types.enum [
                                "compatability"
                                "webgl-1"
                                "webgl-2"
                            ];
                            apply =
                                x:
                                {
                                    "compatability" = "legacy";
                                    "webgl-1" = "webgl1";
                                    "webgl-2" = "webgl2";
                                }
                                ."${x}";
                            description = "The WebGL mode to use for rendering";
                            default = "webgl-2";
                        };
                        tier = mkOption {
                            type = types.enum [
                                "minimal"
                                "low"
                                "medium"
                                "high"
                                "ultra"
                            ];
                            description = "The graphics tier to use for rendering";
                            default = "ultra";
                        };
                        cache = mkOption {
                            type = types.bool;
                            apply = x: if x then "medium" else "low";
                            description = "Whether or not to enable caching of resources";
                            default = true;
                        };
                        particle_count = mkOption {
                            type = with types; either str number;
                            apply = x: percentage x 10 150;
                            description = "How many particles to display (%).";
                            default = 150;
                        };

                        powersave = mkOption {
                            type = types.bool;
                            description = "If enabled, prioritize power saving over performance.";
                            default = false;
                        };
                        low_resolution = mkOption {
                            type = types.bool;
                            description = "If enabled, render blurrier graphics. Not very pretty but helps performance.";
                            default = false;
                        };
                        low_precision_counters = mkOption {
                            type = types.bool;
                            description = "If enabled, don't show as much precision on in-game counters. Speeds up the game significantly.";
                            default = false;
                        };
                    };
                    show_unfocus_warning = mkOption {
                        type = types.bool;
                        description = "If enabled, a warning is shown when TETR.IO is out of focus.";
                        default = true;
                    };
                    action_text = mkOption {
                        type = types.enum [
                            "off"
                            "some"
                            "all"
                        ];
                        description = "Determines how much action text to display when performing special attacks.";
                        default = "some";
                    };
                    board_bounciness = mkOption {
                        type = with types; either str number;
                        apply = x: percentage x 0 200;
                        description = "How much (%) the board reacts when you move pieces around.";
                        default = 40;
                    };
                    damage_shakiness = mkOption {
                        type = with types; either str number;
                        apply = x: percentage x 0 110;
                        description = "How much (%) the board reacts when you receive damage.";
                        default = 100;
                    };
                    grid_opacity = mkOption {
                        type = with types; either str number;
                        apply = x: percentage x 0 110;
                        description = "How visible the grid is (%). 0% makes the grid invisible.";
                        default = 10;
                    };
                    board_opacity = mkOption {
                        type = with types; either str number;
                        apply = x: percentage x 0 110;
                        description = "How visible the board is (%). 0% makes the board invisible.";
                        default = 85;
                    };
                    shadow_opacity = mkOption {
                        type = with types; either str number;
                        apply = x: percentage x 0 110;
                        description = "How visible the shadow piece is (%). 0% makes the shadow piece invisible.";
                        default = 15;
                    };
                    background_opacity = mkOption {
                        type = with types; either str number;
                        apply = x: percentage x 0 100;
                        description = "How visible the background images are. 0% makes the background entirely black.";
                        default = 5;
                    };
                    show_background_in_menus = mkOption {
                        type = types.bool;
                        apply = x: !x;
                        description = "If enabled, do not show the background when in menus. This will majorly improve performance in menus, but you will no longer see the background.";
                        default = false;
                    };
                    board_zoom = mkOption {
                        type = with types; either str number;
                        apply = x: percentage x 0 110;
                        description = "How large the board displays. Values over 100% may cause some elements to not be visible.";
                        default = 100;
                    };
                    spin_board = mkOption {
                        type = types.bool;
                        description = "When enabled, the board reacts to T-Spins by rotating a little with it.";
                        default = true;
                    };
                    fire_meter = mkOption {
                        type = types.bool;
                        description = "If enabled, fill a fire meter when doing well, illuminating boards that have a lot of fire.";
                        default = true;
                    };
                    danger_warning = mkOption {
                        type = types.bool;
                        description = "If enabled, makes the board red and play a warning sound when you're in danger.";
                        default = true;
                    };
                    colored_shadow = mkOption {
                        type = types.bool;
                        description = "If enabled, colors the shadow piece.";
                        default = true;
                    };
                    color_locked_hold_piece = mkOption {
                        type = types.bool;
                        description = "If enabled, the HOLD piece will be grayed out if it may not be used.";
                        default = true;
                    };

                };
            multiplayer = {
                chat = {
                    enable = mkOption {
                        type = types.bool;
                        apply = x: !x;
                        description = "If disabled, chat will be hidden when ingame.";
                        default = true;
                    };
                    filter = mkOption {
                        type = types.bool;
                        description = "If enabled, profanity in chat will be filtered. Note that such filters are never perfect.";
                        default = true;
                    };
                    show_emotes = mkOption {
                        type = types.bool;
                        description = "If enabled, show emotes in chat.";
                        default = true;
                    };
                    show_animated_emotes = mkOption {
                        type = types.bool;
                        description = "If enabled, show animated emotes in chat.";
                        default = true;
                    };
                    invert = mkOption {
                        type = types.bool;
                        description = "If enabled, chat text shows in black (good for light backgrounds).";
                        default = false;
                    };
                    darken = mkOption {
                        type = types.bool;
                        description = "If enabled, show a background behind chat messages when typing.";
                        default = true;
                    };
                };
                notifications =
                    let
                        notification.optional = types.enum [
                            "off"
                            "in-game"
                            "desktop"
                        ];
                        notification.required = types.enum [
                            "in-game"
                            "desktop"
                        ];
                        apply =
                            x:
                            {
                                "off" = "off";
                                "in-game" = "ingame";
                                "desktop" = "both";
                            }
                            ."${x}";
                    in
                    {
                        when = {
                            friend_online = mkOption {
                                type = notification.optional;
                                inherit apply;
                                description = "Notify me when a friend goes online";
                                default = "in-game";
                            };
                            friend_offline = mkOption {
                                type = notification.optional;
                                inherit apply;
                                description = "Notify me when a friend goes offline";
                                default = "off";
                            };
                            friend_dm_recieved = mkOption {
                                type = notification.optional;
                                inherit apply;
                                description = "Notify me when a friend sends me a direct message";
                                default = "desktop";
                            };
                            dm_recieved = mkOption {
                                type = notification.optional;
                                inherit apply;
                                description = "Notify me when a non-friend sends me a direct message";
                                default = "desktop";
                            };
                            room_invite = mkOption {
                                type = notification.required;
                                inherit apply;
                                description = "Notify me when someone invites me to a room";
                                default = "desktop";
                            };
                            other = mkOption {
                                type = notification.required;
                                inherit apply;
                                description = "Other notifications";
                                default = "desktop";
                            };
                        };
                        enable_desktop_notifications = mkOption {
                            type = types.bool;
                            description = "If enabled, show notifications outside of the game.";
                            default = true;
                        };
                        suppress_while_playing = mkOption {
                            type = types.bool;
                            description = "If enabled, unimportant notifications don't show ingame, but will be shown after the game.";
                            default = false;
                        };
                        full_volume = mkOption {
                            type = types.bool;
                            description = "If enabled, notification sounds always play at full volume.";
                            default = true;
                        };
                    };
                hide_room_ids = mkOption {
                    type = types.bool;
                    description = "If enabled, room IDs will not be shown, to protect you from streamsniping.";
                    default = false;
                };
                show_network_warnings = mkOption {
                    type = types.bool;
                    apply = x: !x;
                    description = "If disabled, network warning icons will not be shown.";
                    default = true;
                };
                notify_elim = mkOption {
                    type = types.bool;
                    description = "If enabled, show a popup when you KO someone or get KO'd.";
                    default = true;
                };
                duels_side_by_side = mkOption {
                    type = types.bool;
                    description = "Whether to display a duel side-by-side. This causes your own board to move slightly to the left.";
                    default = true;
                };
                simplify_thumbnails = mkOption {
                    type = types.bool;
                    description = "If enabled, always shows the simpler thumbnails for other players. This increases performance in games between 2 and 8 players, but looks less nice.";
                    default = false;
                };
                animate_super_lobby_background = mkOption {
                    type = types.bool;
                    apply = x: !x;
                    description = "If enabled, the background of Super Lobbies (rooms of 100+ players) animate.";
                    default = true;
                };
                animate_background_in_quickplay = mkOption {
                    type = types.bool;
                    apply = x: !x;
                    description = "If enabled, the background of Quick Play animate.";
                    default = true;
                };
                welcome_guide = mkOption {
                    type = types.bool;
                    description = "If enabled, show the simple guide with the keybinds in multiplayer lobbies.";
                    default = true;
                };
            };
            keep_replay_tools_open = mkOption {
                type = types.bool;
                description = "If enabled, the replay tools do not collapse when you're not using them.";
                default = false;
            };
            skip_login_screen = mkOption {
                type = types.enum [
                    "never"
                    "by-url"
                    "always"
                ];
                apply =
                    x:
                    {
                        "never" = "never";
                        "by-url" = "quickjoin";
                        "always" = "always";
                    }
                    ."${x}";
                description = "When to skip the login screen (\"by-url\": only when joining matches or viewing replays by url)";
                default = "always";
            };
            discord_rpc = mkOption {
                type = types.bool;
                description = "If enabled, show your current activity in Discord.";
                default = true;
            };
            flash_taskbar_icon = mkOption {
                type = types.bool;
                description = "If enabled, the taskbar icon will flash when something important happens.";
                default = true;
            };
            devtools = mkOption {
                type = types.bool;
                description = "If enabled, allow opening the developer toolbox.";
                default = false;
            };
            advertisments.i_support_the_devs.i_cannot_play_with_ads.and_i_really_want_to.disable = mkOption {
                type = types.bool;
                description = "If enabled, most/all third-party ads will not show.";
                default = false;
            };
        };
    };

    config = mkIf cfg.enable (
        lib.mkMerge [
            {
                home.packages = [
                    (cfg.package.override {
                        withTetrioPlus = cfg.plus.enable;
                        tetrio-plus = cfg.plus.package;
                    })
                ];

                home.initialFile.".config/tetrio-desktop/Local Storage/leveldb" = {
                    mode = "0644";
                    source = leveldb {
                        value = {
                            handling =
                                let
                                    set = cfg.settings.handling;
                                in
                                {
                                    arr = set.auto_repeat_rate;
                                    das = set.delayed_auto_shift;
                                    dcd = set.das_cut_delay;
                                    sdf = set.soft_drop_factor;
                                    safelock = set.prevent_hard_drops;
                                    cancel = set.direction_cancel_das;
                                    may20g = set.soft_drop_over_movement;
                                    irs = set.rotation_buffering;
                                    ihs = set.hold_buffering;
                                };
                            volume =
                                let
                                    set = cfg.settings.audio;
                                in
                                {
                                    music = set.music.volume;
                                    bgmtweak = set.music.preferences;
                                    sfx = set.sfx.volume;
                                    stereo = set.stereo;
                                    scrollable = set.scroll_adjust_volume;
                                    oof = set.mute_unfocused;
                                    next = set.sfx.next_pieces;
                                    others = set.sfx.other_players;
                                    attacks = set.sfx.attacks;
                                    zenithrank = set.sfx.speed_changes;
                                    disable = set.disable;
                                };
                            video =
                                let
                                    set = cfg.settings.visual;
                                    mul = cfg.settings.multiplayer;
                                in
                                {
                                    actionText = set.action_text;
                                    bounciness = set.board_bounciness;
                                    shakiness = set.damage_shakiness;
                                    gridopacity = set.grid_opacity;
                                    boardopacity = set.board_opacity;
                                    shadowopacity = set.shadow_opacity;
                                    zoom = set.board_zoom;
                                    sidebyside = mul.duels_side_by_side;
                                    spin = set.spin_board;
                                    kos = mul.notify_elim;
                                    siren = set.danger_warning;
                                    colorshadow = set.colored_shadow;

                                    graphics = set.graphics.tier;
                                    caching = set.graphics.cache;
                                    webgl = set.graphics.pipeline;
                                    particles = set.graphics.particle_count;
                                    background = set.background_opacity;
                                    powersave = set.graphics.powersave;
                                    lowres = set.graphics.low_resolution;
                                    lowrescounters = set.graphics.low_precision_counters;
                                    alwaystiny = mul.simplify_thumbnails;
                                    nosuperlobbyanim = mul.animate_super_lobby_background;
                                    nozenithanim = mul.animate_background_in_quickplay;
                                    nobg = set.show_background_in_menus;
                                    chatfilter = mul.chat.filter;
                                    nochat = mul.chat.enable;
                                    hideroomids = mul.hide_room_ids;
                                    emotes = mul.chat.show_emotes;
                                    emotes_anim = mul.chat.show_animated_emotes;
                                    invert = mul.chat.invert;
                                    chatbg = mul.chat.darken;
                                    replaytoolsnocollapse = cfg.settings.keep_replay_tools_open;
                                    hidenetwork = mul.show_network_warnings;
                                    focuswarning = set.show_unfocus_warning;
                                    guide = mul.welcome_guide;

                                    desktopnotifications = mul.notifications.enable_desktop_notifications;
                                };
                            notifications =
                                let
                                    set = cfg.settings.multiplayer.notifications;
                                in
                                {
                                    suppress = set.suppress_while_playing;
                                    forcesound = set.full_volume;
                                    online = set.when.friend_online;
                                    offline = set.when.friend_offline;
                                    dm = set.when.friend_dm_recieved;
                                    dm_pending = set.when.dm_recieved;
                                    invite = set.when.room_invite;
                                    other = set.when.other;
                                };
                            electron = {
                                loginskip = cfg.settings.skip_login_screen;
                                adblock =
                                    cfg.settings.advertisments.i_support_the_devs.i_cannot_play_with_ads.and_i_really_want_to.disable;
                                taskbarflash = cfg.settings.flash_taskbar_icon;
                                autoupdate = false;
                                anglecompat = false;
                                presence = cfg.settings.discord_rpc;
                                devtools = cfg.settings.devtools;
                            };
                        };
                    };
                    recursive = true;
                };
            }
            (mkIf (cfg.plus.enable) {
                home.file.".config/tetrio-desktop/tetrioplus/tpkey-tetrioPlusEnabled.json" = {
                    text = ''
                        { "value": true }
                    '';
                    force = true;
                };
                home.file.".config/tetrio-desktop/tetrioplus/tpkey-hideTetrioPlusOnStartup.json" = {
                    text = ''
                        { "value": ${lib.trivial.boolToString cfg.plus.hideOnStartup} }
                    '';
                    force = true;
                };
            })
            (mkIf (cfg.plus.enable && cfg.plus ? skin) {
                home.file.".config/tetrio-desktop/tetrioplus/tpkey-skin.json" = {
                    source = cfg.plus.skin.package;
                    force = true;
                };
                home.file.".config/tetrio-desktop/tetrioplus/tpkey-forceNearestScaling.json" = {
                    text = ''
                        			{ "value": ${lib.trivial.boolToString cfg.plus.skin.nearest} }
                        		'';
                    force = true;
                };
            })
        ]
    );
}
