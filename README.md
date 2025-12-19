> [!NOTE]
> This is the `legacy` branch, with _generic_ (`stow` based "hoist-upwards") 
> configurations (be it dated) used with Arch. Personally, I use NixOS now, and 
> those configuration files (alongside up-to-date configs for other things) are 
> available on the `main` branch.

# antonw51's dotfiles

These are my personal configuration files as I use for Arch, i3, Neovim, Fish
shell, and more. There are various prerequsites required for this but those
won't be listed.

## Stow

To make it as easy as possible to install these configuration files, it is
recommended that you use GNU Stow, which is a simple utility that links your files
upwards. To use it, install `stow` from your package manager (like `pacman`):

```bash
$ sudo pacman -S stow
```

Clone this repository to a convenient spot:

```bash
$ git clone --depth=1 https://github.com/antonw51/dotfiles ~/.dotfiles
$ cd ~/.dotfiles
```

> [!IMPORTANT]
> Before stowing, it is recommended to run the `prestow.fish` script so that
> `stow` doesn't link directories such as your entire `.config` folder to
> this directory, instead only files.
>
> This simple script will create empty (unlinked) directories where stow
> expects to force it into linking files only. Remember that any changes made
> even to your home configratuion will be reflected in this repo after linking:
>
> ```bash
> $ ./prestow.fish
> ```
 
Then finally to link all of the necessary configs, run `stow` as such:

```bash
$ stow .
```

> [!NOTE]
> Stow will have problems if you already have any conflicting configuration
> files as found here. Currently the easiest solution to this is to remove your
> pre-existing files. Alternatively you can use the `--adopt` option with stow,
> and then reset this repository to its previous state using `git`.
