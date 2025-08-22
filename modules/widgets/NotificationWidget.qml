import QtQuick
import qs.Settings
import qs.Services

// Battery indicator
Rectangle {
    id: notificationWidget
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
            var notifications = false
            var mute = false
            var icon = "notifications"

            if (mute){
                return "notifications_off"
            }
            if (notifications) {
                return "notifications_unread"
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
            notificationWidget.isHovered = true

            // TODO: Show Battery Stats on Hover
        }
        
        onExited: {
            notificationWidget.isHovered = false
        }
        
        onClicked: function(mouse) {
            console.log("Clicked on Notification!")
            //TODO: Make Pop Up for Power Management
            text.mute = !text.mute
        }
    }
}