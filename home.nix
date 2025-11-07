{ pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "alex";
  home.homeDirectory = "/home/alex";

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    nano
  ];

  home.sessionVariables = {
    EDITOR = "nano";
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history = {
      size = 10000;
      ignoreAllDups = true;
      path = "$HOME/.zsh_history";
      ignorePatterns = [ "rm *" ];
    };

    shellAliases = {
      ls = "ls --color";
      ll = "ls -lah";
      c = "clear";

      gs = "git status -sb";
      gst = "git status";
      gaa = "git add .";
      gau = "git add -u";
      gcm = "git commit -m";
      gca = "git commit -a -m";
      gl = "git log --oneline --graph --all";
    };
  };

  programs.ssh = {
    enable = true;

    matchBlocks."*" = {
      identityAgent = "~/.1password/agent.sock";
    };
  };

  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "tearmaid";
        email = "me@maid.systems";
      };
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };

    signing = {
      format = "ssh";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPGjooEn/yj4qIGy7zeCe/WvdG2ucFSKSad0f9EJz05c";
      signer = "${pkgs._1password-gui}/bin/op-ssh-sign";
      signByDefault = true;
    };
  };

  programs.bat = {
    enable = true;
  };

  programs.fastfetch = {
    enable = true;
  };

  programs.ghostty = {
    enable = true;

    systemd.enable = true;
    enableZshIntegration = true;
    settings = {
      window-width = 120;
      window-height = 35;
      window-padding-color = "background";

      font-family = "0xProto Nerd Font Mono";
      font-size = 12;
      font-feature = "-liga, -calt";

      theme = "Rose Pine Moon";
    };
  };

  programs.vscode = {
    enable = true;

    profiles.default = {
      userSettings = {
        "workbench.colorTheme" = "Rosé Pine Moon (no italics)";
        "workbench.iconTheme" = "material-icon-theme";
        "editor.fontFamily" = "0xProto Nerd Font";
        "editor.formatOnSave" = true;
        "editor.minimap.enabled" = false;
        "chat.disableAIFeatures" = true;
      };

      keybindings = [
        {
          "key" = "ctrl+[Backslash]";
          "command" = "editor.action.commentLine";
          "when" = "editorTextFocus && !editorReadonly";
        }
        {
          "key" = "shift+ctrl+7";
          "command" = "-editor.action.commentLine";
          "when" = "editorTextFocus && !editorReadonly";
        }
      ];

      extensions = with pkgs.vscode-marketplace; [
        esbenp.prettier-vscode
        jnoortheen.nix-ide
        codezombiech.gitignore
        mvllow.rose-pine
        pkief.material-icon-theme
      ];
    };
  };
}
