// Taken from: https://github.com/ryzendew/Reborn-Quickshell/blob/main/.config/quickshell/modules/bar/IndicatorsModule.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland
import qs.Services
import qs.Settings

import "./../widgets"

Rectangle {
    id: indicatorsContainer
    color: "transparent"
    
    MarginWrapperManager { margin: 0 }
        
    RowLayout {
        id: indicatorsRowLayout
        spacing: -10
        anchors {
            top: parent.top
            bottom: parent.bottom
        }
        
        ParallelogramBackdrop {
            fillColor: "#101016"
            BatteryWidget {
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                }
            }
        }

        ParallelogramBackdrop {
            fillColor: "#101016"
            AudioWidget {
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                }
            }
        }
        
        ParallelogramBackdrop {
            fillColor: "#101016"
            MicrophoneWidget{
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                }
            }
        }
        
        ParallelogramBackdrop {
            fillColor: "#101016"
            NetworkStatusWidget{
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                }
            }
        }
        
        ParallelogramBackdrop {
            id: bluetoothBackground
            fillColor: "#101016"
            BluetoothWidget{
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                }
            }
        }
    }
} 