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

Oneliner to install requirements on ubuntu (as root):
```console
sudo apt-get -y update && \
    (   sudo apt-get install -y software-properties-common ; \
        sudo apt-get install -y python-software-properties ; \
    ) ; \
    add-sudo apt-repository -y ppa:neovim-ppa/stable && \
    sudo apt-get -y update && \
    sudo apt install -y cargo curl fzf git neovim stow wmctrl tmux zsh && \
    sudo apt install -y awesome awesome-extra fonts-font-awesome brightnessctl dex x11-xserver-utils i3lock scrot imagemagick xautolock fonts-powerline && \
    cargo install --locked rbw
    git clone --recurse-submodules --remote-submodules --depth 1 -j 2 https://github.com/lcpz/awesome-copycats.git && \
    mv -bv awesome-copycats/{*,.[^.]*} ~/.config/awesome; rm -rf awesome-copycats && \
    git clone https://github.com/albertlauncher/python.git ~/.local/share/albert/python/plugins
    sudo usermod -a -G input ${USER}
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
    ```

## Next Steps
- See [olsonadr/awful-dots](https://github.com/olsonadr/awful-dots/tree/master)
  for additional dotfile scripts/bootstrapping, including automatic gnome
  extention installation and gnome dconf settings management.
