# These modules are added to common so we only have to enable them for a user for them
# to be activated
{ inputs, config, ... }:
let
  wallpaper = "${./wallpaper.jpg}";
  # TODO: move to home-manager option
  yakuake = true;
  homeModules = config.flake.homeModules;
in
{
  flake.nixosModules.desktop =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      someUserHasDesktop = (
        lib.any (value: value.modules.desktop.enable) (builtins.attrValues config.home-manager.users)
      );
    in
    {
      config = lib.mkIf someUserHasDesktop {
        modules.fonts = true;

        # SDDM
        services.displayManager.sddm.enable = true;
        # services.displayManager.autoLogin.user = "user";
        # Set sddm background
        environment.systemPackages = [
          (pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
            [General]
            background=${wallpaper}
          '')
        ];

        # Remove sleep
        systemd.sleep.extraConfig = ''
          AllowSuspend=no
          AllowHybridSleep=no
          AllowHibernation=yes
          AllowSuspendThenHibernate=yes
        '';

        # KDE
        services.desktopManager.plasma6.enable = true;

        # Enable sound with pipewire.
        services.pulseaudio.enable = false;
        security.rtkit.enable = true;
        services.pipewire = {
          enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
          # If you want to use JACK applications, uncomment this
          #jack.enable = true;

          # use the example session manager (no others are packaged yet so this is enabled by default,
          # no need to redefine it in your config for now)
          #media-session.enable = true;
        };

        # Enable touchpad support (enabled default in most desktopManager).
        # services.xserver.libinput.enable = true;

        # Enable the X11 windowing system.
        # You can disable this if you're only using the Wayland session.
        services.xserver.enable = true;

      };
    };

  flake.homeModules.desktop = {
    modules.desktop.enable = true;
  };

  flake.homeModules.kdeconnect = {
    modules.desktop.kdeconnect = true;
  };

  flake.homeModules.desktop' =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.modules.desktop.enable = lib.mkEnableOption "desktop environment";
      options.modules.desktop.kdeconnect = lib.mkEnableOption "kdeconnect";

      config = lib.mkIf config.modules.desktop.enable {
        services.kdeconnect.enable = config.modules.desktop.kdeconnect;

        # Yakuake
        home.packages =
          lib.optionals yakuake [
            pkgs.kdePackages.yakuake
          ]
          ++ [
            pkgs.kdePackages.filelight
          ];

        xdg.autostart = {
          enable = true;
          entries = [
            "${pkgs.kdePackages.yakuake}/share/applications/org.kde.yakuake.desktop"
          ];
        };

        programs.konsole = {
          enable = true;
          customColorSchemes = {
            Breeze = "${./Breeze.colorscheme}";
          };
          defaultProfile = "Default";
          profiles = {
            Default = {
              name = "Default";
              colorScheme = "Breeze";
              command = "zellij -l classic";
              extraConfig = {
                Scrolling.HistoryMode = 0;
                Scrolling.ScrollBarPosition = 2;
              };
            };
          };
        };

        programs.plasma = {
          enable = true;
          overrideConfig = false;

          workspace = {
            lookAndFeel = "org.kde.breezedark.desktop";
            wallpaper = wallpaper;
            enableMiddleClickPaste = false;
          };

          session = {
            sessionRestore.restoreOpenApplicationsOnLogin = "startWithEmptySession";
          };

          kwin = {
            nightLight = {
              enable = true;
              temperature = {
                # day = 6500;
                night = 3100;
              };
            };

            effects = {
              translucency.enable = true;
              blur.enable = false;
            };
          };

          kscreenlocker = {
            lockOnResume = true;
            timeout = 180;
          };

          # panels = [
          #   {
          #     location = "bottom";
          #     opacity = "translucent";
          #     floating = false;
          #     height = 48;
          #     widgets = [
          #       {
          #         kickoff = {
          #           sortAlphabetically = true;
          #           icon = "nix-snowflake";
          #         };
          #       }
          #       {
          #         pager = {
          #           general.showOnlyCurrentScreen = true;
          #         };
          #       }
          #       "org.kde.plasma.systemmonitor.cpucore"
          #       "org.kde.plasma.systemmonitor.memory"
          #       "org.kde.plasma.panelspacer"
          #       {
          #         iconTasks = {
          #           launchers = [
          #             "preferred://filemanager"
          #             "preferred://browser"
          #             "applications:systemsettings.desktop"
          #             "applications:org.kde.konsole.desktop"
          #           ]
          #           ++ lib.optionals config.modules.obsidian.enable [ "applications:obsidian.desktop" ]
          #           ++ lib.optionals config.modules.discord.enable [
          #             "applications:${config.modules.discord.package.meta.mainProgram}.desktop"
          #           ];
          #         };
          #       }
          #       "org.kde.plasma.panelspacer"
          #       {
          #         systemTray.items = {
          #           # We explicitly show bluetooth and battery
          #           shown = [
          #             "org.kde.plasma.battery"
          #             "org.kde.plasma.bluetooth"
          #           ];
          #           hidden = [
          #             # "org.kde.plasma.networkmanagement"
          #             # "org.kde.plasma.volume"
          #           ];
          #         };
          #       }
          #       {
          #         digitalClock = {
          #           calendar.firstDayOfWeek = "monday";
          #           time.format = "24h";
          #           font = {
          #             family = "Noto Sans";
          #             size = 9;
          #             style = "Regular";
          #             weight = 400;
          #           };
          #         };
          #       }
          #       {
          #         name = "org.kde.plasma.minimizeall";
          #         extraConfig = ''
          #             (widget) => {
          #               widget.globalShortcut = "Meta+D";
          #           }
          #         '';
          #       }
          #     ];
          #   }
          # ];

          shortcuts = {
            # Disable Meta+N activating task manager entry N
            plasmashell."activate task manager entry 1" = [ ];
            plasmashell."activate task manager entry 2" = [ ];
            plasmashell."activate task manager entry 3" = [ ];
            plasmashell."activate task manager entry 4" = [ ];
            plasmashell."activate task manager entry 5" = [ ];
            plasmashell."activate task manager entry 6" = [ ];
            plasmashell."activate task manager entry 7" = [ ];
            plasmashell."activate task manager entry 8" = [ ];
            plasmashell."activate task manager entry 9" = [ ];
            plasmashell."activate task manager entry 10" = [ ];
            # Meta+N switches desktop
            kwin."Switch to Desktop 1" = [ "Meta+1" ];
            kwin."Switch to Desktop 2" = [ "Meta+2" ];
            kwin."Switch to Desktop 3" = [ "Meta+3" ];
            kwin."Switch to Desktop 4" = [ "Meta+4" ];
            # Ctrl+D Doesn't show desktop, we have minimizeall shortcut instead
            kwin."Show Desktop" = [ ];
            # Yakuake
            yakuake.toggle-window-state = lib.mkIf yakuake "Meta+Space";
          };

          powerdevil = {
            AC = {
              whenLaptopLidClosed = "hibernate";
            };
            battery = {
              autoSuspend = {
                action = "hibernate";
                idleTimeout = 300;
              };
              whenLaptopLidClosed = "hibernate";
            };
            lowBattery = {
              autoSuspend = {
                action = "hibernate";
                idleTimeout = 60;
              };
              whenLaptopLidClosed = "hibernate";
            };
          };

          configFile = {
            kscreenlockerrc."Greeter/Wallpaper/org.kde.image/General".Image = wallpaper;
            kscreenlockerrc."Greeter/Wallpaper/org.kde.image/General".PreviewImage = wallpaper;
            plasmarc.Wallpapers.usersWallpapers = wallpaper;
            yakuakerc = {
              "Desktop Entry".DefaultProfile = "Default.profile";
              Window = {
                Height = 90;
                ShowTabBar = false;
                ShowTitleBar = false;
              };
              "Dialogs".FirstRun = false;
              "Notification Messages".hinding_title_bar = false;
            };
            kwinrc = {
              Desktops.Number = 4;
              Desktops.Rows = 2;
              Effect-translucency = {
                ComboboxPopups = 99;
                Dialogs = 98;
                Inactive = 96;
                Menus = 99;
                MoveResize = 93;
              };
              # Disable default hot corner
              Effect-overview.BorderActivate = 9;
            };
            breezerc = {
              Common.RoundedCorners = false;
              Style = {
                MenuOpacity = 60;
                WindowDragMode = "WD_NONE";
              };
              Windeco.DrawBackgroundGradient = true;
              "Windeco Exception 0" = {
                BorderSize = 0;
                Enabled = false;
                ExceptionPattern = ".*";
                ExceptionType = 0;
                HideTitleBar = true;
                Mask = 0;
              };
            };
          };
        };
      };
    };

  # Add both modules to common module
  commonHomeModules = [
    config.flake.homeModules.desktop'
  ];
  commonNixosModules = [
    config.flake.nixosModules.desktop
  ];
}
