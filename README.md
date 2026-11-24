# Yadr

Yadr is Yet Another Dotfiles Repo for bootstrapping an nvim, oh-my-tmux, and
zsh dev environment.

## Includes

- [Oh my tmux!](https://github.com/gpakosz/.tmux)
- [ohmyzsh](https://github.com/ohmyzsh/ohmyzsh)
- [Vundle](https://github.com/VundleVim/Vundle.vim?tab=readme-ov-file)
- [LazyVim](https://www.lazyvim.org/)
- [Kanata](https://github.com/jtroo/kanata)
  - [Kenkyo config](https://github.com/argenkiwi/kenkyo/tree/main)

## Usage

### Requirements

- awesome
- awesome-copycats
- cargo
- curl
- fzf
- git
- i3lock
- neovim
- stow
- tmux >= 2.6
- wmctrl
- xautolock
- zsh
- ydotool
- fd-find
- ripgrep
- luarocks
- build-essential
- cmake
- bob
- fnm
- lazygit

Bootstrapping can be done using scripts and per-distro manifests. The main
entrypoint is [scripts/bootstrap.sh](scripts/bootstrap.sh), which autodetects
or accepts a distro name and installs the matching package set from
[configs/bootstrap/distros](configs/bootstrap/distros).

To create a stow selection config interactively, use
[scripts/stow_config_wizard.sh](scripts/stow_config_wizard.sh). Example presets
can be found in [configs/stow](configs/stow).

### Installation

**_WARNING: Backup your dotfiles before installing anything!_**

1. Clone this repo to the homedir as `~/.dotfiles` and enter the clone

   ```bash
   git clone https://github.com/olsonadr/Yadr.git ~/.dotfiles && cd ~/.dotfiles
   ```

2. Run the bootstrap script for your distro

   ```bash
   ./scripts/bootstrap.sh --distro auto --stow-config ./configs/stow/desktop.conf
   ```

   You can also choose a different stow config or generate one with the wizard.

Or, if you are doing the steps manually, without the bootstap script, follow
these steps (instead of step 2 above):

1. Clone all repo submodules if you are doing the steps manually

   ```bash
   ./update_submodules.sh
   ```

2. Install ohmyzsh if you are not using the bootstrap script

   ```bash
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```

3. Backup (or remove) the default `.bashrc`, `.zshrc`, and similar if you are
   not using the bootstrap script

   ```bash
   mv ~/.zshrc{,.default-oh-my-zsh} ; mv ~/.bashrc{,.yadr_backup}
   mv ~/.config/awesome/rc.lua{,.yadr_backup} ; mv ~/.profile{,.yadr_backup}
   ```

4. Install Yadr dotfiles

   ```bash
   ./stow_dots.sh
   ```

- Or install only one set of dotfiles by using a stow config file, or by
  entering the `stow` directory and using stow directly for any `<PROGRAM>`
  (like bash, nvim, tmux, vim, zsh, etc.)

  ```bash
  cd stow && stow -t ${HOME} --no-folding <PROGRAM>
  ```

1. Install (n)vim vundle plugins and themes

   ```bash linenums="$"
   vim -c "PluginInstall"
   nvim -c "PluginInstall"
   ```

2. Install (n)vim autocomplete language server

   ```bash
   sudo apt install mono-complete golang nodejs openjdk-17-jdk openjdk-17-jre npm
   cd ~/.nvim/bundle/YouCompleteMe ; python3 install.py --all ; cd -
   ```

3. Install (and configure) Kanata

## Next Steps

- See [olsonadr/awful-dots](https://github.com/olsonadr/awful-dots/tree/master)
  for additional dotfile scripts/bootstrapping, including automatic gnome
  extention installation and gnome dconf settings management.

## Additional References

- [JetBrainsMono Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip)
- [Ubuntu Hyprland install script](https://github.com/JaKooLit/Ubuntu-Hyprland/tree/main?tab=readme-ov-file)
- [i3lock with fingerprint pam on thikpad](https://bacardi55.io/2023/07/07/i3lock-and-fingerprint/)
- [Updated Kitty install to solve startup lag](https://sw.kovidgoyal.net/kitty/binary/)

## WSL Notes+Issues

- See [misc/WSLTerminalTheme.md](./misc/WSLTerminalTheme.md) for custom color
  schemes for the Windows terminal application
- [Expose cmd.exe to WSL for lazyvim markdown previews](https://github.com/iamcco/markdown-preview.nvim/issues/710)
- [Enable systemd --user for XDG_RUNTIME_DIR errors](https://learn.microsoft.com/en-us/windows/wsl/systemd#code-try-0)
- [Enable systemd in wsl2 (wsl.conf answer)](https://stackoverflow.com/questions/65400999/enable-systemd-in-wsl-2)

## Dots usage (stow, config, secrets, private repos, deploys)

**Stow.** `./stow_dots.sh [-c stowconf] [-i PKG] [-e PKG] [-p PRIVATE_DIR] [-s
SECRETS_FILE] [--no-mirror] [--conflicts prompt|backup|overwrite|fail]
[-- stow-opts]`. Stows `stow/*` plus the packages in `private_dots/`. Use `-- -D`
to unstow. On conflicts, the default interactive prompt shows short text diffs
and matching/different MD5 checksums, then lets you back up and replace, replace
without a backup, inspect the diff/checksum, or apply an action to all remaining
conflicts. Backups are kept next to the original with a `.stow-backup.TIMESTAMP`
suffix. For non-interactive use, choose `--conflicts backup` or
`--conflicts overwrite` explicitly; bootstrap's `--yes` mode backs up conflicts.
Every run also:

1. mirrors the links into `.stow_mirror/` (gitignored; `ls -R` it to see the
   full link set),
2. merges secrets (below), and
3. writes flattened configs to `.scratch/combined/` (gitignored; diff against
   other people's `.bashrc`, `.vimrc`, ...).

**Config.** `cp config.sh.tpl config.sh` (gitignored, plain bash) and edit:
package selection, stow target, mirror, private dir, secrets file, combine. CLI
options override it.

**`.d` layout.** Configs are split into small files that a loader sources in
filename order (`NN-name`; `common.d` + `<shell|vim|nvim>.d` are merged; a
leading `_` or `.bak`/`.off` suffix disables a file). Any stow package can add
files, so tools/orgs contribute independently:

| Dir                                     | Loaded by                                          | Debug                |
| --------------------------------------- | -------------------------------------------------- | -------------------- |
| `~/.shell_rcs/{common,bash,zsh}.d/`     | `~/.bashrc`, `~/.zshrc` (via `~/.shell_loader.sh`) | `SHELL_LOAD_DEBUG=1` |
| `~/.shell_aliases/{common,bash,zsh}.d/` | `common.d/60-aliases.sh`                           | `SHELL_LOAD_DEBUG=1` |
| `~/.vimrc.d/{common,vim,nvim}.d/`       | `~/.vimrc_common`                                  | `VIMRC_D_DEBUG=1`    |
| `~/.tmux.d/*.conf`                      | `~/.tmux.conf.local`                               |                      |

**Private repos.** `private_dots/` (gitignored here; a separate repo) holds
submodules `nxp`, `cognex`, `kul`, `secret`, each a stow package. Select per
machine with `CFG_PRIVATE_INCLUDE/EXCLUDE`. `./update_submodules.sh -f` updates
it too.

**Secrets.** A package that needs credentials ships `secrets.vars` (`VAR` =
required, `?VAR` = optional; never stowed). Each stow merges all manifests into
`~/.config/dots/secrets.env` (mode 600, sourced by the shell). Existing values
are never removed; each missing required variable is warned about. To keep
values in your private repo set `CFG_SECRETS_TRACKED_FILE` (or `-s
secret/secrets.env`); the env file becomes a link to it.

**Temporary deploy (ssh/docker/dir).** `./scripts/dots_remote.sh [-p PKG]...
[-b BINARY]... [-P PREFIX] [-n] TARGET` with `TARGET` = `ssh://[user@]host`,
`docker://[user@]container` (any user, e.g. `docker://dev@mybox`; default is the
container's default user, and the prefix goes in that user's `$HOME`) or
`dir:///path`. Ships only the chosen packages to one
prefix (default `~/.dots_tmp`), never touching existing dotfiles or secrets. On
the target run `~/.dots_tmp/enter [bash|zsh]`; undo with `--clean`; preview
with `-n`. `-b` copies portable binaries (nvim, tmux) into the prefix's `bin/`.

## TODOs

- [ ] Fix hypr animations
- [ ] Fix hypr notification style
- [ ] Fix zsh startup speed
- [ ] Fix libinput gestures
- [ ] Look into why albert wont show applications sometimes
- [ ] Make X/Wayland agnostic scripts for:
  - [ ] xclip/xsel <-> wl-copy/wl-paste
- [x] petertriho/nvim-scrollbar
- [ ] tpope/vim-obsession
- [ ] fix leap binds
- [ ] make binds for fzf (replace ctrl-p?)
- [ ] lazyvim
  - [x] disable smoothscroll, autoformat by default
  - [x] nvim-surround/mini-surround
  - [ ] nvim-cmp errors on windows wsl
  - [ ] add fallback header (if profile picture not present) on dashboard
  - [x] familiar sidebar toggle binds
  - [x] ~add c and y as mini-surround binds in lazy~ (portes the other way around)
  - [x] remove gray hyphens in lazy
  - [x] render markdown
  - [x] pull over binds
  - [x] check lvim into stow
  - [ ] jupyter?
  - [x] enable alt-backspace in command mode
  - [x] hop?
- [x] nvim
  - [x] enable ctrl-s for saving
  - [x] use c+dir for window navigation
- [x] use `<s-h>` and `<s-l>` for buffer navigation in nvimrc
- [x] tmux restore correct version of vim
- [x] move nvims scripts/configs to stow (nvim_skew)
- [x] nvm lazy loading for plugins
- [x] use `<c-hjkl>` for window navigation in nvimrc
- [ ] add readmes for the rough changes made in each rc subdir
- kanata
  - [x] switch kenkyo arrow layer to vim layout
  - [x] updata kanata tap-hold timings to reduce errors
  - [ ] autostart kanata on linux
  - [ ] add kanata instructions
