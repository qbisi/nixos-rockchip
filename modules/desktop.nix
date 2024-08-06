{ pkgs, ... }:
{
  hardware.pulseaudio.enable = true;

  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  systemd.sleep.extraConfig = ''
    # disable hibernation
    # doc : https://archived.forum.manjaro.org/t/turn-off-disable-hibernate-completely/139939
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';
  services.logind.extraConfig = ''
    HibernateKeyIgnoreInhibited=no
  '';

  environment.systemPackages = with pkgs; [
    firefox
    vscode-fhs
    chromium
    nixpkgs-fmt
  ];


  fonts.packages = with pkgs; [
    noto-fonts
    # noto-fonts-cjk-sans
    # noto-fonts-cjk-serif
    source-han-sans
    source-han-serif
    # sarasa-gothic  #更纱黑体
    source-code-pro
    hack-font
    jetbrains-mono
  ];

  # 简单配置一下 fontconfig 字体顺序，以免 fallback 到不想要的字体
  fonts.fontconfig = {
    defaultFonts = {
      emoji = [ "Noto Color Emoji" ];
      monospace = [
        "Noto Sans Mono CJK SC"
        "Sarasa Mono SC"
        "DejaVu Sans Mono"
      ];
      sansSerif = [
        "Noto Sans CJK SC"
        "Source Han Sans SC"
        "DejaVu Sans"
      ];
      serif = [
        "Noto Serif CJK SC"
        "Source Han Serif SC"
        "DejaVu Serif"
      ];
    };
  };

  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "zh_CN.UTF-8/UTF-8"
  ];

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-rime
    ];
  };
}
