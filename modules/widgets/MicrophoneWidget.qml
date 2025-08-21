import QtQuick
import QtQuick.Layouts
import qs.Settings
import qs.Services

// Microphone indicator (single component that changes icon)
Rectangle {
    id: micIndicator
    Layout.fillHeight: true
    Layout.rightMargin: indicatorsRowLayout.realSpacing
    width: Settings.settings.indicatorsSize || 24
    height: Settings.settings.indicatorsSize || 24
    color: "transparent"
    visible: shell
    
    // Hover effects - simple magnification
    property bool isHovered: false
    scale: isHovered ? 1.1 : 1.0
    Behavior on scale {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutCubic
        }
    }
    
    // Local microphone tracking since Pipewire.sourceVolume might not update properly
    property real currentVolume: 0
    property bool currentMuted: false
    
    // Signal to force icon update
    signal muteStateChanged()
    
    Component.onCompleted: {
        // Initialize current volume and mute state
        micIndicator.currentVolume = Pipewire.sourceVolume || 0
        micIndicator.currentMuted = Pipewire.sourceMuted || false
    }
    
    Text {
        anchors.centerIn: parent
        font.family: "Material Symbols Outlined"
        font.pixelSize: Settings.settings.indicatorsSize || 24
        color: "#ffffff"
        
        // Direct property binding for reactive updates
        text: {
            var muted = micIndicator.currentMuted
            var icon = muted ? "mic_off" : "mic"
            return icon
        }
        
        // Listen to mute state changes to force update
        Connections {
            target: micIndicator
            function onMuteStateChanged() {
                // Force text update
                text = text
            }
        }
    }
    
    // Mouse area for microphone control
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        hoverEnabled: true
        
        onEntered: {
            micIndicator.isHovered = true
        }
        
        onExited: {
            micIndicator.isHovered = false
        }
        
        onClicked: function(mouse) {
            if (mouse.button === Qt.LeftButton) {
                // Left click: toggle mute using custom PipeWire service
                if (Pipewire.sourceId) {
                    micIndicator.currentMuted = !micIndicator.currentMuted
                    Pipewire.setSourceMuted(micIndicator.currentMuted)
                    // Force icon update
                    micIndicator.muteStateChanged()
                } else {
                    Pipewire.refreshSource()
                    Pipewire.checkStatus()
                }
            } else if (mouse.button === Qt.RightButton) {
                // Right click: open system volume control
                Quickshell.execDetached(["pavucontrol"])
            }
        }
        
        onWheel: function(wheel) {
            // Scroll wheel: adjust microphone volume
            if (Pipewire.sourceId) {
                var step = 0.05  // 5% steps
                if (wheel.angleDelta.y > 0) {
                    micIndicator.currentVolume = Math.min(1, micIndicator.currentVolume + step)
                    Pipewire.setSourceVolume(micIndicator.currentVolume)
                } else if (wheel.angleDelta.y < 0) {
                    micIndicator.currentVolume = Math.max(0, micIndicator.currentVolume - step)
                    Pipewire.setSourceVolume(micIndicator.currentVolume)
                }
            }
        }
    }
}