{
    pkgs,
    lib ? pkgs.lib,
    config,
    ...
}:

let
    inherit (lib) mkOption types;

    cfg = lib.filterAttrs (n: f: f.enable) config.home.initialFile;
    home = config.home.homeDirectory;
in
{
    options = {
        home.initialFile = mkOption {
            type = types.attrsOf (
                types.submodule (
                    { name, config, ... }:
                    {
                        options = {
                            enable = mkOption {
                                type = types.bool;
                                default = true;
                            };
                            target = mkOption {
                                type = types.str;
                                apply =
                                    path:
                                    let
                                        absPath = if lib.hasPrefix "/" path then path else "${home}/${path}";
                                    in
                                    lib.removePrefix (home + "/") absPath;
                                description = "Path to target file relative to home directory";
                                default = "/homeless-shelter/home";
                            };
                            text = mkOption {
                                type = types.nullOr types.lines;
                                description = "Text of the file, otherwise copies .source file.";
                                default = null;
                            };
                            source = mkOption {
                                type = types.path;
                                description = "Path of file whose source to copy";
                            };
                            mode = mkOption {
                                type = types.nullOr types.str;
                                description = "File mode to apply to target file (sourced from .source / .text if not specified)";
                                default = null;
                            };
                            dir_mode = mkOption {
                                type = types.str;
                                description = "File mode to apply to directories";
                                default = "0755";
                            };
                            recursive = mkOption {
                                type = types.bool;
                                description = "Whether or not to recursively copy .source as a directory instead of as a file";
                                default = false;
                            };
                            force = mkOption {
                                type = types.bool;
                                description = "Whether to unconditionally replace the target file, even if it already exists.";
                                default = false;
                            };
                        };
                        config = {
                            target = lib.mkDefault name;
                            source = lib.mkIf (config.text != null) (
                                lib.mkDefault (
                                    pkgs.writeTextFile {
                                        inherit (config) text;
                                        name = lib.hm.strings.storeFileName name;
                                    }
                                )
                            );
                        };
                    }
                )
            );
            description = "Attribute set of files to write into the user home (if they don't already exist).";
            default = { };
        };
    };

    config = {
        assertions = [
            (
                let
                    dups = lib.attrNames (
                        lib.filterAttrs (n: v: v > 1) (
                            lib.foldAttrs (acc: v: acc + v) 0 (lib.mapAttrsToList (n: v: { ${v.target} = 1; }) cfg)
                        )
                    );
                    dupsStr = lib.concatStringsSep ", " dups;
                in
                {
                    assertion = dups == [ ];
                    message = ''
                        Conflicting managed target files: ${dupsStr}

                        This may happen, for example, if you have a configuration similar to

                            home.initialFile = {
                              conflict1 = { source = ./foo.nix; target = "baz"; };
                              conflict2 = { source = ./bar.nix; target = "baz"; };
                            }'';
                }
            )
        ];

        home.activation.copyInitialFiles = lib.hm.dag.entryAfter [ "writeBoundary" ] (
            let
                homeArg = lib.escapeShellArg home;
            in
            ''
                                function copyFile() {
                                  local source="$1"
                                  local targetRel="$2"
                                  local mode="$3"
                				  local dirMode="$4"
                                  local recursive="$5"
                                  local force="$6"

                                  local target="${homeArg}/$targetRel"

                                  if [[ -e "$target" && "$force" != "true" ]]; then
                                    verboseEcho "Skipping existing $target"
                                    return 0
                                  fi

                                  run mkdir -p "$(dirname "$target")"

                                  if [[ -d "$source" ]]; then
                                    if [[ "$recursive" != "true" ]]; then
                                      errorEcho "Source '$source' is a directory but recursive=false"
                                      return 1
                                    fi
                                    run rm -rf "$target"
                                    run cp -r "$source" "$target"
                                  else
                                    if [[ -e "$target" && "$force" == "true" ]]; then
                                      run rm -f "$target"
                                    fi
                                    run cp "$source" "$target"
                                  fi

                                  if [[ -n "$mode" ]]; then
                                	if [[ -d "$target" && "$recursive" == "true" ]]; then
                					  run chmod "$dirMode" "$target"
                                	  find "$target" -type f -exec chmod "$mode" {} +
                                	else
                                	  run chmod "$mode" "$target"
                                	fi
                                  fi
                                }
            ''
            + lib.concatMapStrings (
                v:
                let
                    src = lib.escapeShellArg (toString v.source);
                    tgt = lib.escapeShellArg v.target;
                    mode = if v.mode == null then "''" else lib.escapeShellArg v.mode;
                in
                ''
                    copyFile ${src} ${tgt} ${mode} ${lib.escapeShellArg v.dir_mode} ${lib.trivial.boolToString v.recursive} ${lib.trivial.boolToString v.force}
                ''
            ) (lib.attrValues cfg)
        );

    };
}
