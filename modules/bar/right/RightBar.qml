import QtQuick
import Quickshell

PanelWindow {
    id: sidebar
    screen: Quickshell.primaryScreen
    // don't reserve space
    exclusionMode: ExclusionMode.Ignore
    color: "transparent"

    anchors {
        right: true
    }

    width: 250
    height: 300
    visible: false

    property bool hovered: false

    // Hover zone: small transparent strip on right screen edge
    PanelWindow {
        id: hoverZone
        screen: sidebar.screen
        anchors {
            right: true
        }
        width: 5
        height: 300
        // implicitHeight: sidebar.height
        color: "green"
        exclusionMode: ExclusionMode.Ignore

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: sidebar.hovered = true
        }
    }

    // Slide in/out on hover
    onHoveredChanged: {
        sidebar.visible = sidebar.hovered
        // if (hovered) {
        //     sidebar.anchors.rightMargin = 0   // show
        // } else {
        //     sidebar.anchors.rightMargin = -sidebar.width   // hide
        // }
    }

     // This rectangle draws the visible panel AND defines the rounded shape
    Rectangle {
        id: bg
        anchors.fill: parent
        bottomLeftRadius: 14
        topLeftRadius: 14
        color: "#1a1a1a"
        border.width: 2
        border.color: "#000000"

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onExited: sidebar.hovered = false
        }

        // Example sidebar content
        Column {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 12

            Text {
                text: "Sidebar"
                color: "white"
                font.pixelSize: 20
            }

            Rectangle {
                width: parent.width
                height: 40
                radius: 6
                color: "steelblue"
            }

            Rectangle {
                width: parent.width
                height: 40
                radius: 6
                color: "steelblue"
            }

            Rectangle {
                width: parent.width
                height: 40
                radius: 6
                color: "steelblue"
            }

            Rectangle {
                width: parent.width
                height: 40
                radius: 6
                color: "steelblue"
            }
        }
    }
}
