{ pkgs, lib, username, userdesc, ... }:

{
  imports = [ 
    ./hardware-configuration.nix
    ./disk-config.nix
    ./impermanence.nix
    ../../modules/audio.nix
    ../../modules/bluetooth.nix
    ../../modules/de/gnome.nix
    ../../modules/flatpak.nix
    ../../modules/games.nix
    ../../modules/locale.nix
    ../../modules/nvidia.nix
    ../../modules/shell/zsh.nix
    ../../modules/system.nix
    ../../modules/stylix.nix
  ];

  users = {
    defaultUserShell = pkgs.zsh;
    mutableUsers = false;
    users.${username} = {
      isNormalUser = true;
      description = userdesc;
      extraGroups = [ "networkmanager" "wheel" "docker" ];
      hashedPassword = "$6$KsXM94WpuFhxSCjz$ci5yTkLvgsOtFbS/ARWWM6lsEjMBo4mKxUuwDxQ3K3LEwU9d/SY0uA.GlCDqulDWOfC0KzTgejqhbvXPlMS6c.";
    };
  };

  networking.extraHosts =
  ''
    127.0.0.1 local.strikerstat-stage.twc1.net
    127.0.0.1 local.strikerstat-preprod.twc1.net
  '';

  services.v2raya.enable = true;

  environment.systemPackages = with pkgs; [
    bitwarden-desktop
    brave
    clash-verge-rev
    claude-code
    #discord
    element-desktop
    gnumake
    gopass
    gpg-tui
    grimblast
    insomnia
    just
    libreoffice-qt
    lunarvim
    prismlauncher
    qbittorrent
    telegram-desktop
    tor-browser
    tuifimanager
    usbutils
    via
    v2rayn
    winetricks
    wineWowPackages.stable
    woeusb
    android-studio 
    jetbrains.idea-ultimate
  ];

  services.flatpak.packages = [
    "com.spotify.Client"
  ];

  programs.nekoray = {
    enable = true;
    tunMode.enable = true;
  };

  programs.appimage.enable = true;
  programs.appimage.binfmt = true;
  programs.appimage.package = pkgs.appimage-run.override {
    extraPkgs = pkgs: [ pkgs.libepoxy ];
  };
}
