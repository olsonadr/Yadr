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

Bootstrap is now driven by scripts and per-distro manifests instead of a single Ubuntu-only one-liner. The main entrypoint is [scripts/bootstrap.sh](scripts/bootstrap.sh), which autodetects or accepts a distro name and installs the matching package set from [configs/bootstrap/distros](configs/bootstrap/distros).

To create a stow selection config interactively, use [scripts/stow_config_wizard.sh](scripts/stow_config_wizard.sh). Example presets live in [configs/stow](configs/stow).

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

Or, if you are doing the steps manually, without the bootstap script, follow these steps (instead of step 2 above):
3. Ensure you have cloned all repo submodules if you are doing the steps manually

   ```bash
   ./update_submodules.sh
   ```

4. Install ohmyzsh if you are not using the bootstrap script

   ```bash
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```

5. Backup (or remove) the default `.bashrc`, `.zshrc`, and similar if you are not using the bootstrap script

   ```bash
   mv ~/.zshrc{,.default-oh-my-zsh} ; mv ~/.bashrc{,.yadr_backup}
   mv ~/.config/awesome/rc.lua{,.yadr_backup} ; mv ~/.profile{,.yadr_backup}
   ```

6. Install Yadr dotfiles

   ```bash
   ./stow_dots.sh
   ```

  - Or install only one set of dotfiles by using a stow config file, or by entering the `stow` directory and using stow directly for any `<PROGRAM>` (like bash, nvim, tmux, vim, zsh, etc.)

     ```bash
     cd stow && stow -t ${HOME} --no-folding <PROGRAM>
     ```

7. Install (n)vim vundle plugins and themes

   ```bash linenums="$"
   vim -c "PluginInstall"
   nvim -c "PluginInstall"
   ```

8. Install (n)vim autocomplete language server

   ```bash
   sudo apt install mono-complete golang nodejs openjdk-17-jdk openjdk-17-jre npm
   cd ~/.nvim/bundle/YouCompleteMe ; python3 install.py --all ; cd -
   ```

9. Install (and configure) Kanata

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
- [ ] nvim
  - [ ] hop?
  - [x] enable ctrl-s for saving
  - [x] use c+dir for window navigation
- [x] use `<s-h>` and `<s-l>` for buffer navigation in nvimrc
- [ ] `<prefix>ctrl+hjkl` for tmux pane expanding?
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

<!-- vim: set ts=4 sw=2 tw=0 et :-->
