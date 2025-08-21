// Based on: https://github.com/ryzendew/Reborn-Quickshell/blob/main/Settings/Settings.qml
pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
// import qs.Services

Singleton {
    property string shellName: "Quickshell"
    property string settingsDir: Quickshell.env("QUICKSHELL_SETTINGS_DIR") || (Quickshell.env("XDG_CONFIG_HOME") || Quickshell.env("HOME") + "/.config") + "/" + shellName + "/"
    property string settingsFile: Quickshell.env("QUICKSHELL_SETTINGS_FILE") || (Quickshell.env("HOME") + "/.local/state/Quickshell/Settings.conf")
    property string themeFile: Quickshell.env("QUICKSHELL_THEME_FILE") || (settingsDir + "Theme.json")
    property var settings: settingAdapter

    Item {
        Component.onCompleted: {
            // ensure settings dir
            Quickshell.execDetached(["mkdir", "-p", settingsDir]);
        }
    }

    FileView {
        id: settingFileView
        path: settingsFile
        watchChanges: true
        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()
        
        Component.onCompleted: function() {
            reload()
        }
        
        onLoaded: function() {
            Qt.callLater(function () {
                // Initialize wallpaper if needed
                if (settings.currentWallpaper) {
                    // WallpaperManager.setCurrentWallpaper(settings.currentWallpaper, true);
                }
            })
        }
        
        onLoadFailed: function(error) {
            // settingAdapter = {}
            writeAdapter()
        }

        JsonAdapter {
            id: settingAdapter
                        
            // User profile
            property string profileImage: Quickshell.env("HOME") + "/.face"
            
            // Wallpaper settings
            property string wallpaperFolder: "~/Pictures/Wallpapers"
            property string currentWallpaper: ""
            property bool randomWallpaper: false
            property bool useWallpaperTheme: false
            property int wallpaperInterval: 300
            property string wallpaperResize: "crop"
            property int transitionFps: 60
            property string transitionType: "random"
            property real transitionDuration: 1.1
            property bool useSWWW: false
            
            // Video settings
            property string videoPath: "~/Videos/"
            
            // UI settings
            property bool showActiveWindowIcon: false
            property bool showSystemInfoInBar: false
            property bool showCorners: true
            property bool showTaskbar: true
            property bool showMediaInBar: false
            property bool barDimmed: true
            property bool dockDimmed: true
            property real fontSizeMultiplier: 1.0
            property int taskbarIconSize: 24
            
            // Bar settings
            property int barHeight: 40
            property string workspaceBorderColor: "transparent"
            property string workspaceIndicatorColor: "#00ffff"
            property int systemTraySize: 24
            property int indicatorsSize: 24
            property int barLogoSize: 40
            
            // Dock settings
            property bool showDock: true
            property bool dockExclusive: false
            property var pinnedExecs: []
            property int dockIconSize: 48
            property int dockHeight: 60
            property int dockIconSpacing: 8
            property int dockBorderWidth: 1
            property int dockRadius: 30
            property string dockBorderColor: "#5700eeff"
            property string dockActiveIndicatorColor: "#00ffff"
            
            // Visualizer settings
            property string visualizerType: "radial"
            
            // Power Managment
            property JsonObject powerOptions: JsonObject{
                property int low: 20
                property int critical: 5
                property int suspend: 3
                property bool automaticSuspend: true
            }

            // Logo settings
            property string barLogo: "NixOSLogo.svg"
            property string dockLogo: "arch-symbolic.svg"
            property string logoColor: "#ffffff"
            
            // Time settings
            property string timeFormat: "24h"
            property string dateFormat: "dd/MM/yyyy"
            property string timezone: "UTC"
            property bool showSeconds: false
            property bool showDate: true
            property bool timeBold: true
            property bool dateBold: false
            property int timeSize: 20
            property int dateSize: 10
            property int timeSpacing: 2
            property string timeColor: "#00eeff"
            property string dateColor: "#848080"
            property string monthFormat: "short"
            
            // Calendar settings
            property string calendarDateFormat: "DD/MM/YYYY"
            property string calendarTimeFormat: "24-hour"
            property string calendarWeekStart: "Sunday"
            property bool calendarShowWeekNumbers: false
            property bool calendarShowTodayHighlight: true
            property string calendarTodayColor: "#00eeff"
            property string calendarSelectedColor: "#5700eeff"
            property string calendarHolidayColor: "#ff6b6b"
            property string calendarHolidayCountry: "US"
            property bool calendarShowHolidays: true
            property bool calendarShowHolidayTooltips: true
            
            // User settings
            property string userImage: ""
        }
    }

    Connections {
        target: settingAdapter
        
        function onRandomWallpaperChanged() {
            // WallpaperManager.toggleRandomWallpaper()
        }
        
        function onWallpaperIntervalChanged() {
            // WallpaperManager.restartRandomWallpaperTimer()
        }
        
        function onWallpaperFolderChanged() {
            // WallpaperManager.loadWallpapers()
        }
    }
} 