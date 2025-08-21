import QtQuick
import Quickshell
import Quickshell.Hyprland

import qs.Settings

import "."
import "./../widgets"

PanelWindow {
    id: panel
    color: "transparent"
    visible: true

    anchors {
        top: true;
        left: true;
        right: true;
    }

    implicitHeight: Settings.settings.barHeight || 40

    ParallelogramBackdrop {
        slantStart: false
        fillColor: "#101016"

        HomeButton {
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
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
            source: "Workspaces.qml"
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    // Indicators module (audio, network, bluetooth status)
    Loader {
        id: indicatorsModule
        anchors {
            right: timeDisplay.left
            verticalCenter: parent.verticalCenter
            rightMargin: 0
        }
        source: "IndicatorsModule.qml"
        
        // Pass shell properties to the indicators
        property var shell: QtObject {
            property int volume: panel.volume
            property bool volumeMuted: panel.volumeMuted
        }
        
        // Pass shell to the loaded component
        onLoaded: {
            indicatorsModule.item.shell = shell
        }
    }

    ParallelogramBackdrop {
        anchors {
            right: parent.right
        }
        fillColor: "#101016"
        slantEnd: false

        TimeDisplay{
            id: timeDisplay
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}