{
  pkgs,
  config,
  hostname,
  username,
  wslhost,
  ...
}:
let
  zshenvExt = ''
    # xdg
    export XDG_CONFIG_HOME="$HOME/.config"
    export XDG_DATA_HOME="$HOME/.local/share"
    export XDG_STATE_HOME="$HOME/.local/state"
    export XDG_CACHE_HOME="$HOME/.cache"

    # misc
    export CARGO_HOME="$HOME/.cargo"
    export RUSTUP_HOME="$HOME/.rustup"
    export DENO_INSTALL="$HOME/.deno"
    export GOPATH="$HOME/.go"
  '';

  zprofileExt = ''
    # Path
    typeset -U path
    typeset -U fpath
    path=(
        "$HOME/.local/bin"(N-/)
        "$HOME/.scripts"(N-/)
        "$CARGO_HOME/bin"(N-/)
        "$DENO_INSTALL/bin"(N-/)
        "$GOPATH/bin"(N-/)
        "$HOME/.local/go/bin"(N-/)
        "$HOME/.dotnet/tools"(N-/)
        "$path[@]"
    )
    fpath=(
        "''${ZDOTDIR:-~}/.zsh_functions"
        "$fpath[@]"
    )

    export EDITOR="nvim"
  '';

  hostZprofileExt = {
    asu = ''
      eval $(/opt/homebrew/bin/brew shellenv)
      export MANPATH=/opt/local/share/man:$MANPATH
      path=(
          "/opt/local/bin:/opt/local/sbin"
          "/Users/${username}/Library/Application Support/JetBrains/Toolbox/scripts"
          "$path[@]"
      )
      fpath=(
          "$(brew --prefix)/share/zsh/site-functions"
          "$fpath[@]"
      )

      # 1Password SSH Agent
      export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
    '';
    yuki = ''
      export SSH_AUTH_SOCK=~/.1password/agent.sock
    '';
    mafu = ''
      export SSH_AUTH_SOCK=~/.1password/agent.sock
    '';
    nacho = ''
      if [ -z "$SSH_CLIENT" ] && [ -n "$SSH_TTY" ]; then
        export SSH_AUTH_SOCK=~/.1password/agent.sock
      fi
    '';
    xanadu = ''
      # RISC-V Toolchain
      path=(
          "/opt/riscv/toolchain/bin"(N-/)
          "$HOME/.rv/riscv-toolchain/bin"(N-/)
          "$path[@]"
      )
    '';
  };

  wslZprofileExt = ''
    path=(
      "$USERPROFILE/AppData/Local/1Password/app/8"
      "$path[@]"
    )
  '';

  zshrcExt = ''
    bindkey "\e[3~" delete-char

    # Title
    autoload -Uz add-zsh-hook
    function _set_title() {
        echo -ne "\033]0;''${USER}@''${HOST}\007"
    }
    function _set_cmd_title() {
        cmd=$(echo ''${2} | awk '{print $1}')
        echo -ne "\033]0;''${cmd}\007"
    }
    add-zsh-hook precmd _set_title
    add-zsh-hook preexec _set_cmd_title

    # Keymap & functions
    ## ghq & fzf
    ## refs: https://gist.github.com/sheepla/d680f1480d8c36c4290d6aabebf1abc6
    function _fzf_cd_ghq() {
        FZF_DEFAULT_OPTS="''${FZF_DEFAULT_OPTS} --reverse --height=50%"
        local root="$(ghq root)"
        local repo="$(ghq list | fzf --preview="ls -AF --color=always ''${root}/{1}")"
        local dir="''${root}/''${repo}"
        [ -n "''${dir}" ] && __zoxide_z "''${dir}" # Use zoxide instead of cd
        zle accept-line
        zle reset-prompt
    }

    zle -N _fzf_cd_ghq
    bindkey -M viins "^g" _fzf_cd_ghq

    ## Fuzzy find history
    function _fzf_select_history(){
        BUFFER=$(history -n -r 1 | fzf --query "$LBUFFER")
        CURSOR=$#BUFFER
        zle reset-prompt
    }

    zle -N _fzf_select_history

    function zvm_after_init() {
        bindkey -M viins "^R" _fzf_select_history
    }

    ## Random Generator
    function rand_str() {
        if [ $# -eq 0 ]; then
            RAND_LEN=16
        else
            RAND_LEN=$1
        fi
        LC_ALL=C tr -dc 'A-Za-z0-9' < /dev/urandom | head -c "$RAND_LEN"; echo
    }

    function rand_sym() {
        if [ $# -eq 0 ]; then
            RAND_LEN=16
        else
            RAND_LEN=$1
        fi
        LC_ALL=C tr -dc 'A-Za-z0-9!"#$%&'\'''()*+,-./:;<=>?@[\]^_`{|}~' < /dev/urandom | head -c "$RAND_LEN"; echo
    }

    function rand_hex() {
        if [ $# -eq 0 ]; then
            RAND_LEN=16
        else
            RAND_LEN=$1
        fi
        LC_ALL=C tr -dc 'a-f0-9' < /dev/urandom | head -c "$RAND_LEN"; echo
    }
  '';

  hostZshrcExt = {
    rika = ''
      alias ssh="/mnt/c/Windows/System32/OpenSSH/ssh.exe"
    '';
    asu = ''
      # sudo prompt
      export SUDO_PROMPT="[sudo] %p's password: "
    '';
    xanadu = ''
      export GPG_TTY=$(tty)
    '';
    nacho = ''
      if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
        export GPG_TTY=$(tty)
      fi
    '';
    unyonyo = ''
      export GPG_TTY=$(tty)
    '';
  };
in
{
  programs = {
    zsh = {
      enable = true;
      dotDir = ".zsh";

      autocd = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = import ./aliases.nix;

      history = {
        # release 24.05 does not have this option
        #append = true;
        ignoreDups = true;
        extended = true;
        path = "$ZDOTDIR/.zsh_history";
        size = 100000;
        save = 100000;
      };

      envExtra = zshenvExt;

      profileExtra =
        zprofileExt + (hostZprofileExt.${hostname} or "") + (if wslhost then wslZprofileExt else "");

      initContent = zshrcExt + (hostZshrcExt.${hostname} or "");

      plugins = [
        {
          name = "vi-mode";
          src = pkgs.zsh-vi-mode;
          file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
        }
        {
          name = "fzf-tab";
          src = pkgs.zsh-fzf-tab;
          file = "share/fzf-tab/fzf-tab.plugin.zsh";
        }
      ];
    };
  };
}
