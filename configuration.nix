{ config, pkgs, inputs, lib, ... }:


{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 0;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;
  
  boot.initrd.systemd.enable = true; 

  boot.kernelParams = [ 
    "quiet" 
    "splash" 
    "boot.shell_on_fail" 
    "loglevel=3" 
    "rd.systemd.show_status=false" 
    "rd.udev.log_level=3" 
    "udev.log_priority=3"
    "fbcon=nodefer"
    "vt.global_cursor_default=0"
  ];
  
  boot.plymouth.enable = true;
  boot.plymouth.theme = "bgrt";
  boot.initrd.kernelModules = [ "i915" "amdgpu" ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 1d";
  };
  nixpkgs.config.allowUnfree = true;

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };

  programs.starship.enable = true;
  programs.thunar.enable = true;
  programs.dconf.enable = true;

  programs.gpu-screen-recorder.enable = true;

  services.gvfs.enable = true;
  services.tumbler.enable = true;
  services.xserver.enable = true;
  services.libinput.enable = true;
  services.flatpak.enable = true;
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
  hardware.bluetooth.enable = true;

  # Configuración de SDDM con el tema Astronaut
  services.displayManager.sddm = {
    enable = true;
    theme = "sddm-astronaut-theme";
    extraPackages = [ pkgs.sddm-astronaut ];
  };

 services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Se cambió a "kde" para que TODAS las apps Qt hereden el tema oscuro global
  qt = {
    enable = true;
    platformTheme = "gtk2";
  };

  # Base de datos global de KDE para asegurar letras blancas en todas las apps Qt
  environment.etc."xdg/kdeglobals".text = ''
    [General]
    ColorScheme=BreezeDark

    [UiSettings]
    ColorScheme=BreezeDark
    ColorSchemePath=BreezeDark.colors

    [Icons]
    Theme=Papirus-Dark
  '';

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = [ "hyprland" "gtk" ];
  };

  # Configuración global para aplicaciones GTK (Gnome/Thunar/etc)
  programs.dconf.profiles.user.databases = [{
    settings = with lib.gvariant; {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme = "adw-gtk3-dark";
        icon-theme = "Papirus-Dark";
        cursor-theme = "Bibata-Modern-Classic";
        cursor-size = mkInt32 24;
      };
    };
  }];

  environment.variables = {
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";
  };

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  time.timeZone = "America/Caracas";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_VE.UTF-8";
    LC_IDENTIFICATION = "es_VE.UTF-8";
    LC_MEASUREMENT = "es_VE.UTF-8";
    LC_MONETARY = "es_VE.UTF-8";
    LC_NAME = "es_VE.UTF-8";
    LC_NUMERIC = "es_VE.UTF-8";
    LC_PAPER = "es_VE.UTF-8";
    LC_TELEPHONE = "es_VE.UTF-8";
    LC_TIME = "es_VE.UTF-8";
  };

  services.xserver.xkb = {
    layout = "latam";
    variant = "";
  };

  console.keyMap = "la-latin1";

  users.users."neny" = {
    isNormalUser = true;
    description = "neny";
    extraGroups = [ "networkmanager" "wheel" "adbusers" ];
    packages = with pkgs; [];
  };

  environment.systemPackages = with pkgs; [
    inputs.caelestia-shell.packages.${pkgs.system}.with-cli
    onlyoffice-desktopeditors
    gsettings-desktop-schemas
    nerd-fonts.jetbrains-mono
    adwaita-icon-theme
    hicolor-icon-theme
    papirus-icon-theme
    qt6.qtimageformats
    qt5.qtimageformats
    nerd-fonts.hack
    kdePackages.breeze
    kdePackages.kdenlive    
    kdePackages.breeze-icons
    bibata-cursors
    protonvpn-gui
    android-tools
    sddm-astronaut
    xfce.xfconf
    fastfetch
    tty-clock
    vscodium
    vesktop
    pipes
    python3
    adw-gtk3
    libadwaita
    nwg-look
    spotify
    brave
    kitty
    p7zip
    unzip
    unrar
    cava
    glib
    foot
    zip
    git
  ];

  system.stateVersion = "26.11";
}
