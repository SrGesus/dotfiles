{
  myLib,
  lib,
  config,
  pkgs,
  ...
}:
let
  # wallpapers = builtins.map builtins.toString (myLib.listFilesWithSuffixRecursive "" ./wallpapers);
  wallpaper = "${./wallpaper.jpg}";
  yakuake = true;
in
{
  options.modules.graphical = lib.mkEnableOption "graphical";

  config = lib.mkIf config.modules.graphical {

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
          extraConfig = {
            # "Scrolling".HistoryMode = 0;
            Scrolling.ScrollBarPosition = 2;
          };
        };
      };
    };

    programs.plasma = {
      enable = true;
      overrideConfig = true;

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
        timeout = 0;
      };

      panels = [
        {
          location = "bottom";
          opacity = "translucent";
          floating = false;
          extraSettings = ''
            panel.floatingApplets = "true";
          '';
          widgets = [
            {
              kickoff = {
                sortAlphabetically = true;
                icon = "nix-snowflake";
              };
            }
            {
              pager = {
                general.showOnlyCurrentScreen = true;
              };
            }
            "org.kde.plasma.systemmonitor.cpucore"
            "org.kde.plasma.systemmonitor.memory"
            "org.kde.plasma.panelspacer"
            {
              iconTasks = {
                launchers = [
                  "preferred://filemanager"
                  "preferred://browser"
                  "applications:systemsettings.desktop"
                  "applications:org.kde.konsole.desktop"
                ]
                ++ lib.optionals config.modules.obsidian.enable [ "applications:obsidian.desktop" ];
              };
            }
            "org.kde.plasma.panelspacer"
            {
              systemTray.items = {
                # We explicitly show bluetooth and battery
                shown = [
                  "org.kde.plasma.battery"
                  "org.kde.plasma.bluetooth"
                ];
                hidden = [
                  # "org.kde.plasma.networkmanagement"
                  # "org.kde.plasma.volume"
                ];
              };
            }
            {
              digitalClock = {
                calendar.firstDayOfWeek = "monday";
                time.format = "24h";
                font = {
                  family = "Noto Sans";
                  size = 9;
                  style = "Regular";
                  weight = 400;
                };
              };
            }
            {
              name = "org.kde.plasma.minimizeall";
              extraConfig = ''
                  (widget) => {
                    widget.globalShortcut = "Meta+D";
                }
              '';
            }
          ];
        }
      ];

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
          whenLaptopLidClosed = "hibernate";
        };
        lowBattery = {
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
}
