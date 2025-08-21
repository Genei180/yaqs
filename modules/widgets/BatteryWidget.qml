import QtQuick
import QtQuick.Layouts
import qs.Settings
import qs.Services

// Battery indicator
Rectangle {
    id: batteryWidget
    implicitWidth: text.implicitWidth
    color: "transparent"
    
    // Hover effects - simple magnification
    property bool isHovered: false
    scale: isHovered ? 1.1 : 1.0
    Behavior on scale {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutCubic
        }
    }
                
    Text {
        id: text
        anchors.centerIn: parent
        font.family: "Material Symbols Outlined"
        font.pixelSize: parent.height - Settings.settings.itemPadding
        color: "#ffffff"
        
        // Direct property binding for reactive updates
        text: {
            var percentage = BatteryService.percentage
            var icon = ""

            if (BatteryService.isCharging) {
                if (percentage >= 90) return "battery_charging_90";
                if (percentage >= 80) return "battery_charging_80";
                if (percentage >= 60) return "battery_charging_60";
                if (percentage >= 50) return "battery_charging_50";
                if (percentage >= 30) return "battery_charging_30";
                if (percentage >= 10) return "battery_charging_20";
                return "battery_charging_full" // looks Empty \-.-/
            }else{
                if (percentage >= 98) return "battery_full";
                if (percentage >= 90) return "battery_6_bar";
                if (percentage >= 80) return "battery_5_bar";
                if (percentage >= 60) return "battery_4_bar";
                if (percentage >= 40) return "battery_3_bar";
                if (percentage >= 30) return "battery_2_bar";
                if (BatteryService.isLow) return "battery_1_bar"; // 20
                if (BatteryService.isCritical) return "battery_alert"; // 10
            }
            
            return icon
        }
    }

    // Mouse area for volume control
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        hoverEnabled: true
        
        onEntered: {
            batteryWidget.isHovered = true

            // TODO: Show Battery Stats on Hover
        }
        
        onExited: {
            batteryWidget.isHovered = false
        }
        
        onClicked: function(mouse) {
            console.log("Clicked on Battery!")
            //TODO: Make Pop Up for Power Management
        }
    }
}