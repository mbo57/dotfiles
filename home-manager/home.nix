{ config, lib, pkgs, pkgs-unstable, inputs, ... }:
let
  pkgs-old = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/86744fef91ab55030c60f1fea68eaedf59773930.tar.gz";
    sha256 = "10hw736d2m058g15gidkx8f54z7j0i04zvgw2pdx07ba468kdqpv";
  }) { system = "x86_64-linux"; };  # 古いnixpkgs
in
{
  imports = [
    # ./hyprland
  ];
  
  nixpkgs.config.allowUnfree = true;
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "mbo57";
  home.homeDirectory = "/home/mbo57";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    brave
    discord-ptb
    # uxplay
    # avahi
    # nssmdns

    zsh-completions
    zsh-history-substring-search

    ripgrep
    tree
    jq
    xclip
    bc
    
    # alsa-utils

    # fcitx5
    # fcitx5-mozc
    # xdg-desktop-portal-hyprland  # Hyprland用ポータル
    # xdg-desktop-portal-gtk       # GTKアプリ用ポータル

    deno
    nodejs
    go
    cargo
    rustc
    gcc

    # fonts
    font-awesome

    nmap
    # ike-scan

    mise
    gemini-cli

    typst

    gnuplot

    google-chrome
  ] ++ (with pkgs-old; [
    (pkgs.writeShellScriptBin "gnuplot-4.6.6" ''
      exec ${gnuplot}/bin/gnuplot "$@"
    '')
  ]) ++ (with pkgs-unstable; [
    claude-code
  ]);

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
        libsForQt5.fcitx5-qt
        qt6Packages.fcitx5-qt
        qt6Packages.fcitx5-configtool
      ];
      settings = {
        inputMethod = {
          GroupOrder = {
            "0" = "Default";
          };
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us";
            DefaultIM = "mozc";
          };
          "Groups/0/Items/0" = {
            Name = "keyboard-us";
            Layout = "";
          };
          "Groups/0/Items/1" = {
            Name = "mozc";
            Layout = "";
          };
        };
        globalOptions = {
          "Hotkey/TriggerKeys" = {
            "0" = "Control+space";
            "1" = "Zenkaku_Hankaku";
            "2" = "Hangul";
            "3" = "Super+space";
          };
          "Hotkey/AltTriggerKeys" = {
            "0" = "Shift_L";
          };
          "Hotkey/EnumerateGroupForwardKeys" = {
            "0" = "Super+space";
          };
          "Hotkey/EnumerateGroupBackwardKeys" = {
            "0" = "Shift+Super+space";
          };
          "Hotkey/ActivateKeys" = {
            "0" = "Hangul_Hanja";
          };
          "Hotkey/DeactivateKeys" = {
            "0" = "Hangul_Romaja";
          };
          "Hotkey/PrevPage" = {
            "0" = "Up";
          };
          "Hotkey/NextPage" = {
            "0" = "Down";
          };
          "Hotkey/PrevCandidate" = {
            "0" = "Shift+Tab";
          };
          "Hotkey/NextCandidate" = {
            "0" = "Tab";
          };
          "Hotkey/TogglePreedit" = {
            "0" = "Control+Alt+P";
          };
          "Hotkey" = {
            EnumerateWithTriggerKeys = "True";
            EnumerateForwardKeys = "";
            EnumerateBackwardKeys = "";
            EnumerateSkipFirst = "False";
            ModifierOnlyKeyTimeout = "250";
          };
          "Behavior" = {
            ActiveByDefault = "False";
            resetStateWhenFocusIn = "No";
            ShareInputState = "Program";  # ← 変更: アプリケーション間で状態を共有
            PreeditEnabledByDefault = "True";
            ShowInputMethodInformation = "True";
            showInputMethodInformationWhenFocusIn = "False";
            CompactInputMethodInformation = "True";
            ShowFirstInputMethodInformation = "True";
            DefaultPageSize = "5";
            OverrideXkbOption = "False";
            CustomXkbOption = "";
            EnabledAddons = "";
            DisabledAddons = "";
            PreloadInputMethod = "True";
            AllowInputMethodForPassword = "False";
            ShowPreeditForPassword = "False";
            AutoSavePeriod = "30";
          };
        };
        addons = {
          clipboard = {
            globalSection = {
              TriggerKey =  "Alt+V";
              "Number of entries" = 5;
            };
            sections = {
            };
          };
        };
      };
    };
  };

  # fcitx5-daemonサービスに環境変数と依存関係を追加
  systemd.user.services.fcitx5-daemon = {
    Unit = {
      After = lib.mkForce [ "graphical-session.target" ];
      PartOf = lib.mkForce [ "graphical-session.target" ];
    };
    Service = {
      Environment = lib.mkForce [
        "FCITX_ADDON_DIRS=${pkgs.fcitx5-mozc}/lib/fcitx5"
        "LD_LIBRARY_PATH=${pkgs.fcitx5-mozc}/lib:${pkgs.fcitx5}/lib"
      ];
    };
  };

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      initContent = ''
        bindkey -e
        autoload -Uz compinit && compinit
        zstyle ':completion:*' menu select
        zstyle ':completion:*' group-name ""
        zstyle ':completion:*' list-colors ""
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
        bindkey '^[[A' history-beginning-search-backward
        bindkey '^[[B' history-beginning-search-forward

        # __git_ps1 を有効化
        source ${pkgs.git}/share/git/contrib/completion/git-prompt.sh

        export LSCOLORS='gxfxcxdxbxegedabagacad'
        export LS_COLORS='di=96:ln=35:so=32:pi=33:ex=32:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
        setopt PROMPT_SUBST
        PROMPT='%f%*%b:%F{green}%n@%m%f%b:%F{cyan}%~%F{yellow}$(__git_ps1) %f'$'\n'"$%f "
        alias ls="ls -G --color"
        # fcitx5の環境変数は systemd.user.services で設定
      '';
    };
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/mbo57/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx"; 
    XMODIFIERS = "@im=fcitx";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
