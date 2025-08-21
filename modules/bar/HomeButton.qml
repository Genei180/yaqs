import QtQuick
import QtQuick.Layouts
import "."
import qs.Settings
import qs.Services

Rectangle {

    id: homeButton
    implicitWidth: logoImage.width + 10
    radius: logoImage.width / 2
    color: homeMouseArea.containsMouse ? "#252525" : "transparent"
    // border.color: homeMouseArea.containsMouse ? "#555555" : "transparent"
    // border.width: homeMouseArea.containsMouse ? 1 : 0

    Image {
        id: logoImage
        anchors{
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }
        width: (Settings.settings.barLogoSize || 24)
        height: (Settings.settings.barLogoSize || 24)
        source: "./../../assets/OSLogo.svg"
        fillMode: Image.PreserveAspectFit
        smooth: false
        mipmap: true
        cache: true
        sourceSize.width: 64
        sourceSize.height: 64
    }

    // Dynamic color overlay for the logo
    // ColorOverlay {
    //     anchors.fill: dockLogoImage
    //     source: dockLogoImage
    //     color: LogoService.logoColor
    // }

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

    Behavior on border.color {
        ColorAnimation {
            duration: 150
            easing.type: Easing.OutQuad
        }
    }

}