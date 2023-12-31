# https://nixos.org/manual/nixos/stable/
# https://github.com/ryan4yin/nixos-and-flakes-book

{ config, pkgs, ... }:

{
  home.username = "stephen";
  home.homeDirectory = "/home/stephen";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # set cursor size and dpi for 4k monitor
  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # here is some command line tools I use frequently
    # feel free to add your own or remove some of them

    # system
    neofetch # prettified info - https://github.com/dylanaraps/neofetch
    nnn # file manager - https://github.com/jarun/nnn

    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processer https://github.com/mikefarah/yq
    fzf # A command-line fuzzy finder

    # networking tools
    mtr # A network diagnostic tool
    iperf3
    dnsutils  # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc  # it is a calculator for the IPv4/v6 addresses

    # misc
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    # productivity
    hugo # static site generator - https://github.com/gohugoio/hugo

    btop  # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb

    # fonts
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })

    # programs
    discord
    virtualbox

    # dev shell
    direnv # https://determinate.systems/posts/nix-direnv - https://github.com/nix-community/nix-direnv

    # languages
    terraform

    # compiler infrastructure
    llvmPackages_rocm.clang
  ];

  programs.bash = {
    enable = true;
#     enableCompletion = true;
#     bashrcExtra = ''
#       export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
#     '';
#
#     # set some aliases, feel free to add more or remove some
#     shellAliases = {
#       # example aliases:
#       # k = "kubectl";
#       # urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
#       # urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
#     };
  };

  programs.fish = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
  };

  # alacritty - a cross-platform, GPU-accelerated terminal emulator
  programs.alacritty = {
    enable = false;
    # custom settings
    settings = {
      env.TERM = "xterm-256color";
      font = {
        size = 12;
        draw_bold_text_with_bright_colors = true;
      };
      scrolling.multiplier = 5;
      selection.save_to_clipboard = true;
    };
  };

  fonts.fontconfig.enable = true;

  # starship - an customizable prompt for any shell
  programs.starship = {
    enable = true;
    # custom settings
    settings = {
      add_newline = false;
      line_break.disabled = true;
    };
  };

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "Stephen Andary";
    userEmail = "stephen@jamminmusic.com";
    includes = [{ path = "~/.gitconfig.local"; }];
     extraConfig = {
      init.defaultBranch = "main";
      gpg.format = "ssh";
      user.signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINzr8FZekPLkBcPkbTcSQKxRghTk0MnOTbxs+KtVqRNN"; # public
      gpg."ssh".program = "${pkgs._1password-gui}/bin/op-ssh-sign";
      commit.gpgsign = true;
    };
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    mutableExtensionsDir = true;
  };

  programs.ssh = {
    enable = true;
    forwardAgent = true;
    extraConfig = "IdentityAgent ${config.home.homeDirectory}/.1password/agent.sock";
  };

  programs.chromium = {
    enable = true;
    package = pkgs.google-chrome;
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
