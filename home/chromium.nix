{
    enable = true;

    defaultSearchProviderEnabled = true;
    defaultSearchProviderSuggestURL = "https://duckduckgo.com/?q={searchTerms}&type=list";
    defaultSearchProviderSearchURL = "https://duckduckgo.com/?q={searchTerms}";

    extraOpts =
        let
            languagetool = "oldceeleldhonbafppcapldpdifcinji";
            shortkeys = "logpjaacgmcbpdkdchjiaagddngobkck";
            darkreader = "eimadpbcbfnmbkopoojfekhnkhdbieeh";
            ublock = "ddkjiahejlhfcafbddmgiahcphecmpfh";
        in
        {
            extensions = {
                install.initiallist = [
                    languagetool
                    shortkeys
                    darkreader
                    ublock
                ];
                commands."linux:Alt+Left" = {
                    command_name = "04-prevtab";
                    extension = shortkeys;
                    global = false;
                };
                commands."linux:Alt+Right" = {
                    command_name = "03-nexttab";
                    extension = shortkeys;
                    global = false;

                };
            };
            message_center.disabled_extension_ids = [ shortkeys ];
            profile.content_settings.permission_actions = {
                mic_stream = [ { action = 2; } ];
                notifications = [ { action = 2; } ];
            };
        };
}
