# Yadr
Yadr is Yet Another Dotfiles Repo for bootstrapping an nvim, oh-my-tmux, and zsh dev environment.

## Includes
- [Oh my tmux!](https://github.com/gpakosz/.tmux)
- [ohmyzsh](https://github.com/ohmyzsh/ohmyzsh)
- [Vundle](https://github.com/VundleVim/Vundle.vim?tab=readme-ov-file)

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

Oneliner to install requirements on ubuntu (as root):
```console
sudo apt-get -y update && \
    (   sudo apt-get install -y software-properties-common ; \
        sudo apt-get install -y python-software-properties ; \
    ) ; \
    add-sudo apt-repository -y ppa:neovim-ppa/stable && \
    sudo apt-get -y update && \
    sudo apt install -y cargo curl fzf git neovim stow wmctrl tmux zsh ydotool && \
    sudo apt install -y awesome awesome-extra fonts-font-awesome brightnessctl dex x11-xserver-utils i3lock scrot imagemagick xautolock fonts-powerline python3-pynvim && \
    cargo install --locked rbw
    git clone --recurse-submodules --remote-submodules --depth 1 -j 2 https://github.com/lcpz/awesome-copycats.git && \
    mv -bv awesome-copycats/{*,.[^.]*} ~/.config/awesome; rm -rf awesome-copycats && \
    git clone https://github.com/albertlauncher/python.git ~/.local/share/albert/python/plugins && \
    sudo usermod -a -G input ${USER} && \
    sudo usermod -a -G video ${USER}
```

### Installation
***WARNING: Backup your dotfiles before installing anything!***

1. Clone this repo to the homedir as `~/.dotfiles` and enter the clone
    ```console
    git clone https://github.com/olsonadr/Yadr.git ~/.dotfiles && cd ~/.dotfiles
    ```
2. Ensure you have cloned all repo submodules
    ```console
    ./update_submodules.sh
    ```
3. Install ohmyzsh
    ```console
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    ```
4. Backup (or remove) the default `.bashrc`, `.zshrc`, and similar
    ```console
    mv ~/.zshrc{,.default-oh-my-zsh} && mv ~/.bashrc{,.yadr_backup} && mv ~/.config/awesome/rc.lua{,.yadr_backup}
    ```
5. Install Yadr dotfiles
    ```console
    ./stow_dots.sh
    ```
    - Or install only one set of dotfiles by entering the `stow` directory, and using stow directly for any <PROGRAM> (like bash, nvim, tmux, vim, zsh, etc.)
        ```console
        cd stow && stow -t ~ --no-folding <PROGRAM>
        ```
6. Install (n)vim vundle plugins and themes
    ```console
    vim -c "PluginInstall"
    nvim -c "PluginInstall"
    ```
7. Install (n)vim autocomplete language server
    ```console
    sudo apt install mono-complete golang nodejs openjdk-17-jdk openjdk-17-jre npm
    cd ~/.nvim/bundle/YouCompleteMe ; python3 install.py --all ; cd -
    ```

## Next Steps
- See [olsonadr/awful-dots](https://github.com/olsonadr/awful-dots/tree/master)
  for additional dotfile scripts/bootstrapping, including automatic gnome
  extention installation and gnome dconf settings management.

## Additional References
- [https://github.com/JaKooLit/Ubuntu-Hyprland/tree/main?tab=readme-ov-file](Potential Ubuntu Hyprland install script)
- [https://bacardi55.io/2023/07/07/i3lock-and-fingerprint/](i3lock with fingerprint pam on thikpad)
- [https://sw.kovidgoyal.net/kitty/binary/](Updated Kitty install to solve startup lag)

## TODOs
- [ ] Fix libinput gestures
- [ ] Look into why albert wont show applications sometimes
- [ ] Make X/Wayland agnostic scripts for:
    - [ ] xclip/xsel <-> wl-copy/wl-paste
