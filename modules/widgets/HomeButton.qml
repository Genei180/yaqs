import QtQuick
import QtQuick.Layouts
import "."
import qs.Settings
import qs.Services

Rectangle {
    implicitWidth: logoImage.width + 10
    color: "transparent"

    Rectangle {
        id: homeButton
        implicitWidth: logoImage.width
        radius: (Settings.settings.barLogoSize || 24) / 2
        color: homeMouseArea.containsMouse ? "#252525" : "transparent"
        Image {
            id: logoImage
            width: (Settings.settings.barLogoSize || 24)
            height: (Settings.settings.barLogoSize || 24)
            source: "./../../assets/"+Settings.settings.barLogo
            fillMode: Image.PreserveAspectFit
        }
        anchors {
            top: parent.top
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }
    }

    MouseArea {
        id: homeMouseArea
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            homeButton.isHovered = true
        }
        onExited: {
            homeButton.isHovered = false
        }
        onClicked: {
            // Open power settings tab
            SettingsManager.openSettingsTab(3)  // Power tab index
        }
    }

    // Smooth scale animation like other dock icons
    property bool isHovered: false

    onIsHoveredChanged: {
        if (isHovered) {
            scale = 1.1
        } else {
            scale = 1.0
        }
    }

    Behavior on scale {
        NumberAnimation {
            duration: 150
            easing.type: Easing.OutQuad
        }
    }

    Behavior on color {
        ColorAnimation {
            duration: 150
            easing.type: Easing.OutQuad
        }
    }
}