# Yadr

Yadr is Yet Another Dotfiles Repo for bootstrapping an nvim, oh-my-tmux, and zsh dev environment.

## Includes

- [Oh my tmux!](https://github.com/gpakosz/.tmux)
- [ohmyzsh](https://github.com/ohmyzsh/ohmyzsh)
- [Vundle](https://github.com/VundleVim/Vundle.vim?tab=readme-ov-file)
- [LazyVim](https://www.lazyvim.org/)

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

Oneliner to install requirements on ubuntu (as root):

```bash
sudo apt-get -y update && \
    (   sudo apt-get install -y software-properties-common ; \
        sudo apt-get install -y python-software-properties ; \
    ) ; \
    sudo apt-get -y update && \
    sudo apt install -y cargo curl build-essential cmake fzf git neovim stow wmctrl tmux zsh ydotool && \
    sudo apt install -y awesome awesome-extra fonts-font-awesome brightnessctl dex x11-xserver-utils i3lock scrot imagemagick xautolock fonts-powerline python3-pynvim && \
    cargo install --locked rbw
    git clone --recurse-submodules --remote-submodules --depth 1 -j 2 https://github.com/lcpz/awesome-copycats.git && \
    mv -bv awesome-copycats/{*,.[^.]*} ~/.config/awesome; rm -rf awesome-copycats && \
    git clone https://github.com/albertlauncher/python.git ~/.local/share/albert/python/plugins && \
    sudo usermod -a -G input ${USER} && \
    sudo usermod -a -G video ${USER} && \
    sudo apt install -y fd-find ripgrep luarocks && \
    cargo install bob-nvim && bob use latest && \
    cargo install fnm && fnm install v22 && fnm default v22 && \
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*') && \
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" && \
    tar xf lazygit.tar.gz lazygit && \
    sudo install lazygit -D -t /usr/local/bin/ && rm lazygit{,tar.gz}
```

### Installation

**_WARNING: Backup your dotfiles before installing anything!_**

1. Clone this repo to the homedir as `~/.dotfiles` and enter the clone

   ```bash
   git clone https://github.com/olsonadr/Yadr.git ~/.dotfiles && cd ~/.dotfiles
   ```

2. Ensure you have cloned all repo submodules

   ```bash
   ./update_submodules.sh
   ```

3. Install ohmyzsh

   ```bash
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```

4. Backup (or remove) the default `.bashrc`, `.zshrc`, and similar

   ```bash
   mv ~/.zshrc{,.default-oh-my-zsh} && mv ~/.bashrc{,.yadr_backup} && mv ~/.config/awesome/rc.lua{,.yadr_backup}
   ```

5. Install Yadr dotfiles

   ```bash
   ./stow_dots.sh
   ```

   - Or install only one set of dotfiles by entering the `stow` directory, and using stow directly for any <PROGRAM> (like bash, nvim, tmux, vim, zsh, etc.)

     ```bash
     cd stow && stow -t ${HOME} --no-folding <PROGRAM>
     ```

6. Install (n)vim vundle plugins and themes

   ```bash linenums="$"
   vim -c "PluginInstall"
   nvim -c "PluginInstall"
   ```

7. Install (n)vim autocomplete language server

   ```bash
   sudo apt install mono-complete golang nodejs openjdk-17-jdk openjdk-17-jre npm
   cd ~/.nvim/bundle/YouCompleteMe ; python3 install.py --all ; cd -
   ```

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

- See [misc/WSLTerminalTheme.md](./misc/WSLTerminalTheme.md) for custom color schemes for the Windows terminal application
- [Expose cmd.exe to WSL for lazyvim markdown previews](https://github.com/iamcco/markdown-preview.nvim/issues/710)
- [Enable systemd --user for XDG_RUNTIME_DIR errors](https://learn.microsoft.com/en-us/windows/wsl/systemd#code-try-0)
- [Enable systemd in wsl2 (wsl.conf answer)](https://stackoverflow.com/questions/65400999/enable-systemd-in-wsl-2)

## TODOs

- [ ] Fix libinput gestures
- [ ] Look into why albert wont show applications sometimes
- [ ] Make X/Wayland agnostic scripts for:
  - [ ] xclip/xsel <-> wl-copy/wl-paste
- [ ] petertriho/nvim-scrollbar
- [ ] tpope/vim-obsession
- [ ] fix leap binds
- [ ] make binds for fzf (replace ctrl-p?)
- [ ] lazyvim
  - [ ] nvim-surround/mini-surround
- [ ] render markdown
  - [ ] pull over binds
  - [ ] check lvim into stow
- [ ] jupyter?
- [x] tmux restore correct version of vim
- [x] move nvims scripts/configs to stow (nvim_skew)
- [ ] `<prefix>ctrl+hjkl` for tmux pane expanding?
- [x] nvm lazy loading for plugins

<!-- vim: set ts=4 sw=4 tw=0 et :-->
