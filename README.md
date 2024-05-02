# Yadr
Yadr is Yet Another Dotfiles Repo for bootstrapping an nvim, oh-my-tmux, and zsh dev environment.

## Includes
- [Oh my tmux!](https://github.com/gpakosz/.tmux)
- [ohmyzsh](https://github.com/ohmyzsh/ohmyzsh)
- [Vundle](https://github.com/VundleVim/Vundle.vim?tab=readme-ov-file)

## Usage
### Requirements
- curl
- fzf
- git
- neovim
- stow
- tmux >= 2.6
- zsh

Oneliner to install requirements on ubuntu (as root):
```console
apt-get -y update && \
    (   apt-get install -y software-properties-common ; \
        apt-get install -y python-software-properties ; \
    ) ; \
    add-apt-repository -y ppa:neovim-ppa/stable && \
    apt-get -y update && apt install -y curl fzf git neovim stow tmux zsh
```

### Installation
***WARNING: Backup your dotfiles before installing anything!***

1. Clone this repo to the homedir as `~/.dotfiles` and enter the clone
    ```console
    git clone https://github.com/olsonadr/Yadr.git ~/.dotfiles && cd ~/.dotfiles
    ```
2. Ensure you have cloned all repo submodules
    ```console
    git submodule update --init --recursive
    ```
3. Install ohmyzsh
    ```console
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    ```
4. Backup (or remove) the default `.bashrc` and `.zshrc`
    ```console
    mv ~/.zshrc ~/.zshrc.default-oh-my-zsh && mv ~/.bashrc ~/.bashrc.yadr_backup
    ```
5. Install Yadr dotfiles
    ```console
    ./stow_dots.sh
    ```
    - Or install only one set of dotfiles by entering the `stow` directory, and using stow directly for any <PROGRAM> (like bash, nvim, tmux, vim, zsh, etc.)
        ```console
        cd stow && stow -t ~ <PROGRAM>
        ```
    - Install (n)vim vundle plugins and themes
        ```console
        vim -c "PluginInstall"
        ```

## Next Steps
- See [olsonadr/awful-dots](https://github.com/olsonadr/awful-dots/tree/master)
  for additional dotfile scripts/bootstrapping, including automatic gnome
  extention installation and gnome dconf settings management.
