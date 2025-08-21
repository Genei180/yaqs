// Taken from: https://github.com/ryzendew/Reborn-Quickshell/blob/main/modules/bar/Components/clock.qml
import QtQuick
import QtQuick.Layouts
import qs.Settings
import qs.Services

Rectangle {
    id: clock
    color: "#000000"
    radius: 5
    
    // Hover effects - simple magnification
    property bool isHovered: false
    
    // Hover magnification animation
    scale: isHovered ? 1.1 : 1.0
    Behavior on scale {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutCubic
        }
    }
    
    property string currentDate: ""
    property string currentTime: ""
    
    // Main layout
    ColumnLayout {
        id: timeLayout
        anchors.centerIn: parent
        spacing: TimeService.timeSpacing
        
        // Time display
        Text {
            id: timeText
            text: clock.currentTime
            color: TimeService.timeColor
            font.pixelSize: TimeService.timeSize * (Settings.settings.fontSizeMultiplier || 1.0)
            font.family: "Inter, sans-serif"
            font.bold: TimeService.timeBold
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            opacity: 1.0  // Ensure text is fully opaque
        }

                // Date display
        Text {
            id: dateText
            text: clock.currentDate
            color: TimeService.dateColor
            font.pixelSize: TimeService.dateSize * (Settings.settings.fontSizeMultiplier || 1.0)
            font.family: "Inter, sans-serif"
            font.bold: TimeService.dateBold
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            opacity: 1.0  // Ensure text is fully opaque
            visible: TimeService.showDate
        }
    }
    
    // Set implicit dimensions based on layout
    implicitWidth: timeLayout.implicitWidth
    implicitHeight: timeLayout.implicitHeight
    
    // Update time every second
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            updateTime()
        }
    }
    
    // Listen for time service changes
    Connections {
        target: TimeService
        function onTimeSettingsChanged() {
            updateTime()
        }
    }
    
    function updateTime() {
            var now = new Date()
        clock.currentDate = TimeService.formatDate(now)
        clock.currentTime = TimeService.formatTime(now)
    }
    
    // Initialize time immediately
    Component.onCompleted: {
        updateTime()
    }
    
    // Mouse area for clicking
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        
        onEntered: {
            clock.isHovered = true
        }
        
        onExited: {
            clock.isHovered = false
        }
        
        onClicked: {
            // Open settings window with calendar tab
            openCalendarTab()
        }
    }
    
    // Function to open calendar tab
    function openCalendarTab() {
        // Use the SettingsManager service to open the calendar tab
        SettingsManager.openSettingsTab(4)  // Calendar tab index
    }
} 