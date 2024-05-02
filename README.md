# Yadr
Yadr is Yet Another Dotfiles Repo for bootstrapping an nvim, oh-my-tmux, and zsh dev environment.

## Includes
- [Oh my tmux!](https://github.com/gpakosz/.tmux)
- [ohmyzsh](https://github.com/ohmyzsh/ohmyzsh)

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
# apt-get -y update && \
    (   apt-get install -y software-properties-common ; \
        apt-get install -y python-software-properties ; \
    ) ; \
    add-apt-repository -y ppa:neovim-ppa/stable && \
    apt-get -y update && apt install -y curl fzf git neovim stow tmux zsh
```

### Installation
***WARNING: Backup your dotfiles before installing anything!***

1. Ensure you have cloned all repo submodules
    ```console
    $ git submodule update --init --recursive
    ```
2. Clone this repo to the homedir as `~/.dotfiles` and enter the clone
    ```console
    $ git clone https://github.com/olsonadr/Yadr.git ~/.dotfiles && cd ~/.dotfiles
    ```
3. Install ohmyzsh
    ```console
    $ sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    ```
4. Backup (or remove) the default `.zshrc`
    ```console
    $ mv ~/.zshrc ~/.zshrc.default-oh-my-zsh
    ```
5. Install *all* Yadr dotfiles
    ```console
    $ stow */
    ```
    - Or install only one set of dotfiles by replacing `*/` with a single program with dotfiles (like bash, nvim, tmux, vim, zsh, etc.)

