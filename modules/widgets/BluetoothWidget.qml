import QtQuick
import QtQuick.Layouts
import qs.Settings
import qs.Services

// Bluetooth indicator
Rectangle {
    id: bluetoothIndicatorRect
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
        text: {
            if (Bluetooth.connectedDevices.length > 0) return "bluetooth_connected"
            if (Bluetooth.bluetoothEnabled) return "bluetooth"
            return "bluetooth_disabled"
        }
        font.family: "Material Symbols Outlined"
        font.pixelSize: parent.height - Settings.settings.itemPadding
        color: "#ffffff"
    }
    
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        
        onEntered: {
            bluetoothIndicatorRect.isHovered = true
        }
        
        onExited: {
            bluetoothIndicatorRect.isHovered = false
        }
        
        onClicked: {
            // Open Bluetooth settings tab
            SettingsManager.openSettingsTab(1)  // Bluetooth tab index
        }
    }
}