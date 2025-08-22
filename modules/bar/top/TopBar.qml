import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs.Settings

import "./../../widgets"

PanelWindow {
    id: panel
    color: "transparent"
    visible: true

    anchors {
        top: true;
        left: true;
        right: true;
    }

    implicitHeight: Settings.settings.barHeight

    ParallelogramBackdrop {
        slantStart: false
        fillColor: "#101016"
        HomeButton {
            anchors {
                top: parent.top
                bottom: parent.bottom
            }
        }
    }

    ParallelogramBackdrop {
        anchors {
            centerIn: parent
        }
        fillColor: "#101016"

        // Workspace in the Center
        Loader {
            source: "./../../widgets/Workspaces.qml"
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    // Indicators module (audio, network, bluetooth status)
    Loader {
        id: indicatorsModule
        anchors {
            right: clock.left
            rightMargin: -10
            top: parent.top
            bottom: parent.bottom
        }
        source: "IndicatorsModule.qml"
    }

    ParallelogramBackdrop {
        id: clock
        anchors {
            right: parent.right
        }
        fillColor: "#101016"
        slantEnd: false

        Clock{
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}