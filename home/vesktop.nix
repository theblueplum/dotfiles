{
    enable = true;
    settings = {
        discordBranch = "stable";
        tray = true;
        minimizeToTray = false;
        enableMenu = true;
        hardwareAcceleration = true;
        arRPC = true;

        enableSplashScreen = false;
        splashTheming = false;
    };
    vencord.settings = {
        autoUpdate = true;
        autoUpdateNotification = false;
        notifyAboutUpdates = false;
        useQuickCss = true;
        disableMinSize = true;
        plugins = {
            CommandsAPI.enabled = true;
            DynamicImageModalAPI.enabled = true;
            MemberListDecoratorsAPI.enabled = true;
            MessageAccessoriesAPI.enabled = true;
            MessageDecorationsAPI.enabled = true;
            MessageEventsAPI.enabled = true;
            MessageUpdaterAPI.enabled = true;
            ServerListAPI.enabled = true;
            UserSettingsAPI.enabled = true;
            AlwaysExpandRoles.enabled = true;
            AlwaysTrust.enabled = true;
            AnonymiseFileNames.enabled = true;
            BetterGifPicker.enabled = true;
            BetterSettings = {
                enabled = true;
                disableFade = true;
                organizeMenu = true;
                eagerLoad = true;
            };
            BetterUploadButton.enabled = true;
            BiggerStreamPreview.enabled = true;
            BlurNSFW.enabled = true;
            CallTimer.enabled = true;
            ConsoleJanitor = {
                enabled = true;
                disableLoggers = false;
                disableSpotifyLogger = true;
                whitelistedLoggers = "GatewaySocket; Routing/Utils";
                allowLevel = {
                    error = true;
                    warn = false;
                    trace = false;
                    log = false;
                    info = false;
                    debug = false;
                };
            };
            CopyEmojiMarkdown.enabled = true;
            CrashHandler.enabled = true;
            CtrlEnterSend = {
                enabled = false;
                submitRule = "ctrl+enter";
                sendMessageInTheMiddleOfACodeBlock = true;
            };
            CustomIdle = {
                enabled = true;
                idleTimeout = 10;
                remainInIdle = true;
            };
            DisableCallIdle.enabled = true;
            ExpressionCloner.enabled = true;
            F8Break.enabled = true;
            FakeNitro = {
                enabled = true;
                enableEmojiBypass = true;
                emojiSize = 48;
                transformEmojis = true;
                enableStickerBypass = true;
                stickerSize = 160;
                transformStickers = true;
                transformCompoundSentence = false;
                enableStreamQualityBypass = true;
                useHyperLinks = true;
                hyperLinkText = "{{NAME}}";
                disableEmbedPermissionCheck = false;
            };
            FakeProfileThemes = {
                enabled = true;
                nitroFirst = true;
            };
            FavoriteEmojiFirst.enabled = true;
            FixCodeblockGap.enabled = true;
            FixImagesQuality.enabled = true;
            FixSpotifyEmbeds = {
                enabled = true;
                volume = 10;
            };
            FixYoutubeEmbeds.enabled = true;
            ForceOwnerCrown.enabled = true;
            FriendsSince.enabled = true;
            FullSearchContext.enabled = true;
            FullUserInChatbox.enabled = true;
            GameActivityToggle.enabled = true;
            IgnoreActivities = {
                enabled = false;
                listMode = 0;
                idsList = "";
                ignorePlaying = false;
                ignoreStreaming = false;
                ignoreListening = false;
                ignoreWatching = false;
                ignoreCompeting = false;
            };
            ImageFilename.enabled = true;
            IrcColors = {
                enabled = true;
                lightness = 70;
                memberListColors = true;
                applyColorOnlyToUsersWithoutColor = false;
                applyColorOnlyInDms = false;
            };
            LoadingQuotes = {
                enabled = true;
                replaceEvents = true;
                enablePluginPresetQuotes = true;
                enableDiscordPresetQuotes = true;
                additionalQuotes = "";
                additionalQuotesDelimiter = "|";
            };
            MemberCount.enabled = true;
            MessageClickActions.enabled = true;
            MessageLatency = {
                enabled = true;
                latency = 1;
                detectDiscordKotlin = true;
                showMillis = false;
                ignoreSelf = false;
            };
            MessageLogger = {
                enabled = true;
                deleteStyle = "text";
                logDeletes = true;
                collapseDeleted = false;
                logEdits = true;
                inlineEdits = true;
                ignoreBots = false;
                ignoreSelf = false;
                ignoreUsers = "";
                ignoreChannels = "";
                ignoreGuilds = "";
            };
            NewGuildSettings = {
                enabled = true;
                guild = true;
                messages = 1;
                everyone = true;
                role = true;
                highlights = true;
                events = true;
                showAllChannels = true;
            };
            NoDevtoolsWarning.enabled = true;
            NoF1.enabled = true;
            NoMosaic = {
                enabled = false;
                inlineVideo = true;
            };
            NoServerEmojis.enabled = true;
            NormalizeMessageLinks.enabled = true;
            NotificationVolume = {
                enabled = false;
                notificationVolume = 100;
            };
            OnePingPerDM.enabled = true;
            PauseInvitesForever.enabled = true;
            PermissionFreeWill = {
                enabled = false;
                lockout = true;
                onboarding = true;
            };
            PermissionsViewer.enabled = true;
            PinDMs = {
                enabled = false;
                pinOrder = 0;
                canCollapseDmSection = false;
            };
            PlatformIndicators.enabled = true;
            PreviewMessage.enabled = true;
            QuickReply.enabled = true;
            ReactErrorDecoder.enabled = true;
            RelationshipNotifier.enabled = true;
            ReplaceGoogleSearch = {
                enabled = false;
                replacementEngine = "off";
            };
            ReplyTimestamp.enabled = true;
            RevealAllSpoilers.enabled = true;
            RoleColorEverywhere.enabled = true;
            SecretRingToneEnabler = {
                enabled = false;
                onlySnow = false;
            };
            Summaries = {
                enabled = true;
                summaryExpiryThresholdDays = 3;
            };
            SendTimestamps = {
                enabled = true;
                replaceMessageContents = true;
            };
            ServerInfo.enabled = true;
            ServerListIndicators.enabled = true;
            ShikiCodeblocks = {
                enabled = true;
                theme = "https://raw.githubusercontent.com/shikijs/textmate-grammars-themes/2d87559c7601a928b9f7e0f0dda243d2fb6d4499/packages/tm-themes/themes/dark-plus.json";
                tryHljs = "SECONDARY";
                useDevIcon = "GREYSCALE";
                bgOpacity = 100;
            };
            ShowHiddenChannels.enabled = true;
            ShowHiddenThings = {
                enabled = true;
                showTimeouts = true;
                showInvitesPaused = true;
                showModView = true;
            };
            ShowMeYourName = {
                enabled = true;
                mode = "nick-user";
                friendNicknames = "dms";
                displayNames = false;
                inReplies = false;
            };
            SilentMessageToggle.enabled = true;
            SilentTyping.enabled = true;
            SpotifyControls.enabled = true;
            SpotifyCrack.enabled = true;
            SpotifyShareCommands.enabled = true;
            SuperReactionTweaks = {
                enabled = true;
                superReactByDefault = false;
                unlimitedSuperReactionPlaying = false;
                superReactionPlayingLimit = 0;
            };
            TextReplace = {
                enabled = false;
                stringRules = [
                    {
                        find = "";
                        replace = "";
                        onlyIfIncludes = "";
                    }
                ];
                regexRules = [
                    {
                        find = "";
                        replace = "";
                        onlyIfIncludes = "";
                    }
                ];
            };
            TypingIndicator.enabled = true;
            TypingTweaks = {
                enabled = true;
                showAvatars = true;
                showRoleColors = true;
                alternativeFormatting = true;
            };
            UserMessagesPronouns = {
                enabled = true;
                pronounsFormat = "LOWERCASE";
                showSelf = true;
            };
            UserVoiceShow.enabled = true;
            ValidReply.enabled = true;
            ValidUser.enabled = true;
            VoiceChatDoubleClick.enabled = true;
            VcNarrator = {
                enabled = false;
                voice = "us-mbrola-1 espeak-ng-mbrola";
                volume = 1;
                rate = 1;
                sayOwnName = false;
                latinOnly = false;
                joinMessage = "{{USER}} joined";
                leaveMessage = "{{USER}} left";
                moveMessage = "{{USER}} moved to {{CHANNEL}}";
                muteMessage = "{{USER}} muted";
                unmuteMessage = "{{USER}} unmuted";
                deafenMessage = "{{USER}} deafened";
                undeafenMessage = "{{USER}} undeafened";
            };
            ViewRaw.enabled = true;
            VoiceMessages.enabled = true;
            VolumeBooster = {
                enabled = true;
                multiplier = 3;
            };
            WebKeybinds.enabled = true;
            WebScreenShareFixes.enabled = true;
            WhoReacted.enabled = true;
            BadgeAPI.enabled = true;
            NoTrack = {
                enabled = true;
                disableAnalytics = true;
            };
            Settings = {
                enabled = true;
                settingsLocation = "aboveNitro";
            };
            DisableDeepLinks.enabled = true;
            SupportHelper.enabled = true;
            WebContextMenus.enabled = true;
        };
    };
}
