# PATH modifications
export PATH="/usr/share/Modules/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:${PATH}"
export PATH="${HOME}/.vimpkg/bin:${PATH}"
export PATH="${HOME}/.local/bin:${PATH}"
export PATH="${HOME}/.cargo/bin:${PATH}"
export PATH="${HOME}/bin:${PATH}"
export PATH="/snap/bin:${PATH}"
export PATH="${HOME}/.local/share/bob/nvim-bin:${PATH}"
export PATH="${HOME}/go/bin:${PATH}"
export PATH="${HOME}/Documents/flutter/flutter/bin:${PATH}"
export PATH="${HOME}/.opencode/bin:${PATH}"

#export PATH="${PATH}:/usr/local/bin/JLink_Linux_V794e_x86_64"

# Common secrets
[[ -d /usr/local/go/bin ]] && export PATH="$PATH:/usr/local/go/bin"
