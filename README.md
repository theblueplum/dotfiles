# BluePlum's dotfiles

Sup. This repository is representative of my personal configuration files
(available [here at https://github.com/antonw51/dotfiles](https://github.com/antonw51/dotfiles)).

Feel free to look at, pick and choose, fork, or do whatever you want with
these. That's kind of the point.

See what I consider my dotfiles to be at [the Preferences section](#Preferences)

## Installation

### NixOS

This entire repository is representative of a `/etc/nixos` directory for use
with NixOS. Installing these dotfiles is hence easiest on NixOS.

To do so, you'll need `git`, your favorite editor and the root priviliges for
your system. (For a bare NixOS system `nix-shell` suffices:)

```bash
$ nix-shell -p git
```

Clone this repository into a folder that's ideally owned by your user account
rather than root (or just use `sudo` for the following steps). Then copy its
contents into the `/etc/nixos` directory.

```bash
# Remove existing configuration
$ [ -f /etc/nixos/configuration.nix ]
    && sudo rm /etc/nixos/configuration.nix 

$ git clone https://github.com/antonw51/dotfiles ~/dotfiles
$ sudo cp -r ~/dotfiles/* /etc/nixos
```

You will also need to make a `.env.nix` file for device specific configuration.
`nixos-rebuild build` will tell you which keys need to be filled out, but the
current minimal config looks like (`/etc/nixos/.env.nix`):

```nix
{ ... }:

{
    hostname = "pinklilac"
}
```

> [!INFO]
>
> This `.env.nix` file configures some keys shared across the configuration.
> Namely this `hostname` property which declares `system.networking.hostname`
> _and_ adds a nix file at `/etc/nixos/{hostname}.nix` (where `{hostname}` is
> your hostname) to `configuration.nix` module `imports`.
>
> With this you can configure per-device specifics, such as displays, or
> additional configuration. See `blueplum.nix` for an example.

Thereafter you can run `sudo nixos-rebuild boot` to build the configuration and
`reboot` to apply it appropriately.

If you forked or own the repository and want to cleanly keep the git repository
seperated from write-protected `/etc/` files to commit to the repository, you
can move the `git` file and `.git` directories contents to another more
permanent directory:

```bash
# In this example, the persistent directory will be ~/dev/nixos

$ mkdir -p ~/dev/nixos
$ mv -r ~/dotfiles/.git/* ~/dev/nixos
$ mv ~/dotfiles/git ~/dev/nixos && chmod +x ~/dev/nixos/git

# Optionally remove the originally cloned directory:
$ rm -r ~/dotfiles # git metadata is preserved.
```

Then use the `git` executable (with `fish`) in the new directory to interact with the repository held in `/etc/nixos`:

```bash
$ cd ~/dev/nixos
$ ./git add .
$ ./git commit
$ ./git push
# ...
```

### Other

NixOS allows for reproducible and easily configurable configuration files both
system- and user-wide. It makes the installation process a lot easier.

Without NixOS to manage your system, you'll have to configure and "generate"
configs yourself. For most things, `git`, `i3`, and packages alike this
consists of essentially translating the contents of files such as `home.nix` or
`home/i3.nix` into equivilant configuration.

However, program configurations within the `pkgs` directory don't have this
constraint, as they're defined as traditional configs and then simply copied.
These you can copy or symlink to quickly set up the appropriate software. (For
instance, to set up Fish, you can link `pkgs/fish` to your local
`$__fish_config_dir`.)

If you choose this approach, set up symlinks, and want to commit/contribute to
the git repository contained within the dotfiles, you may do so within the
cloned repository; no need to move anything or use any special git scripts.

## Preferences

While I don't _necessarily_ follow any specific ideologies when
making/modifying my dotfiles, I do typically:

- Try and keep things to essentials (not minimalistic, but nothing overkill)
- Personally familiar (keyboard shortcuts might not be to your liking)
- With _some_ expansion in mind (`.env.nix` for example)
- Somewhat consistent (The IBM Carbon colors are currently a personal favorite
  of mine)
- Formatted and linted consistently (Lua, Nix, and Fish files are all
  formatted, and I try to keep them up to high, consistent standard)
- Ephermeral (I won't live forever, duh, and this ain't a group project)
- Somewhat informational? (You're reading this `README`, afterall)
- Redacted (You won't find sensitive things here, perhaps outside of my name,
  which is rather obvious already)
- Fine-tuned (Irks, even minor I do my best to iron out while trying to keep
  away from hacky patches)
