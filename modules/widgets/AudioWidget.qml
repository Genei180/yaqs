import QtQuick
import QtQuick.Layouts
import qs.Settings
import qs.Services

// Volume indicator (single component that changes icon)
Rectangle {
    id: volumeIndicator
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
    
    // Local volume tracking since Pipewire.sinkVolume might not update properly
    property real currentVolume: 0
    property bool currentMuted: false
    
    Component.onCompleted: {
        // Initialize current volume from shell
        if (shell && shell.volume) {
            volumeIndicator.currentVolume = shell.volume / 100
        }
        // Initialize current mute state from shell
        if (shell) {
            volumeIndicator.currentMuted = shell.volumeMuted
        }
        
        // Also try to get initial state from Pipewire service
        if (Pipewire && Pipewire.sinkMuted !== undefined) {
            volumeIndicator.currentMuted = Pipewire.sinkMuted
        }
        if (Pipewire && Pipewire.sinkVolume !== undefined) {
            volumeIndicator.currentVolume = Pipewire.sinkVolume
        }
    }
    
    // Update local state when Pipewire service changes
    Connections {
        target: Pipewire
        function onSinkMutedChanged() {
            if (Pipewire.sinkMuted !== undefined) {
                volumeIndicator.currentMuted = Pipewire.sinkMuted
                // Update shell mute state for icon and OSD
                if (shell) {
                    shell.volumeMuted = volumeIndicator.currentMuted
                }
            }
        }
        
        function onSinkVolumeChanged() {
            if (Pipewire.sinkVolume !== undefined) {
                volumeIndicator.currentVolume = Pipewire.sinkVolume
                // Update shell volume for icon and OSD
                if (shell) {
                    shell.volume = Math.round(volumeIndicator.currentVolume * 100)
                }
            }
        }
    }
    
    Text {
        anchors.centerIn: parent
        font.family: "Material Symbols Outlined"
        font.pixelSize: Settings.settings.indicatorsSize || 24
        color: "#ffffff"
        
        // Direct property binding for reactive updates
        text: {
            var muted = volumeIndicator.currentMuted
            var volume = shell ? shell.volume : 0
            var icon = ""
            
            if (muted) {
                icon = "volume_off"
            } else if (volume === 0) {
                icon = "volume_off"
            } else if (volume < 30) {
                icon = "volume_down"
            } else {
                icon = "volume_up"
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
            volumeIndicator.isHovered = true
        }
        
        onExited: {
            volumeIndicator.isHovered = false
        }
        
        onClicked: function(mouse) {
            if (mouse.button === Qt.LeftButton) {
                // Left click: toggle mute using shell's toggleMute method
                if (shell && typeof shell.toggleMute === 'function') {
                    shell.toggleMute()
                    console.log("Volume indicator: Toggled mute via shell")
                } else if (Pipewire && Pipewire.sinkId) {
                    // Fallback: toggle mute using custom PipeWire service
                    const newMutedState = !volumeIndicator.currentMuted
                    volumeIndicator.currentMuted = newMutedState
                    
                    // Call the Pipewire service to actually mute/unmute
                    try {
                        Pipewire.setSinkMuted(newMutedState)
                        console.log("Volume indicator: Toggled mute to:", newMutedState)
                    } catch (e) {
                        console.log("Volume indicator: Error setting mute:", e.message)
                        // Revert local state if the call failed
                        volumeIndicator.currentMuted = !newMutedState
                    }
                    
                    // Update shell mute state for icon and OSD
                    if (shell) {
                        shell.volumeMuted = volumeIndicator.currentMuted
                    }
                } else {
                    console.log("Volume indicator: No default sink available, refreshing...")
                    if (Pipewire && typeof Pipewire.refreshSink === 'function') {
                        Pipewire.refreshSink()
                    }
                    if (Pipewire && typeof Pipewire.checkStatus === 'function') {
                        Pipewire.checkStatus()
                    }
                }
            } else if (mouse.button === Qt.RightButton) {
                // Right click: open system volume control
                Quickshell.execDetached(["pavucontrol"])
            }
        }
        
        onWheel: function(wheel) {
            // Scroll wheel: adjust volume using shell's updateVolume method (similar to Noctalia)
            if (shell && typeof shell.updateVolume === 'function') {
                var step = 5  // 5% steps in percentage
                // Convert current volume to percentage for easier calculation
                let currentVolumePercent = Math.round(volumeIndicator.currentVolume * 100)
                
                let newVolumePercent = currentVolumePercent
                
                if (wheel.angleDelta.y > 0) {
                    newVolumePercent = Math.min(100, currentVolumePercent + step)
                } else if (wheel.angleDelta.y < 0) {
                    newVolumePercent = Math.max(0, currentVolumePercent - step)
                }
                
                // Only update if volume actually changed
                if (newVolumePercent !== currentVolumePercent) {
                    // Update local state immediately
                    volumeIndicator.currentVolume = newVolumePercent / 100
                    
                    // Call shell's updateVolume method
                    try {
                        shell.updateVolume(newVolumePercent)
                        console.log("Volume indicator: Changed volume to:", newVolumePercent, "% via shell")
                    } catch (e) {
                        console.log("Volume indicator: Error setting volume:", e.message)
                        // Revert local state if the call failed
                        volumeIndicator.currentVolume = currentVolumePercent / 100
                    }
                    
                    // Update shell volume for icon and OSD
                    if (shell) {
                        shell.volume = newVolumePercent
                    }
                }
            } else if (Pipewire && Pipewire.sinkId) {
                // Fallback: use custom PipeWire service
                var step = 0.05  // 5% steps
                // Use a local variable to track volume since Pipewire.sinkVolume might not update
                if (!volumeIndicator.currentVolume) {
                    volumeIndicator.currentVolume = Pipewire.sinkVolume || 0
                }
                
                let newVolume = volumeIndicator.currentVolume
                
                if (wheel.angleDelta.y > 0) {
                    newVolume = Math.min(1, volumeIndicator.currentVolume + step)
                } else if (wheel.angleDelta.y < 0) {
                    newVolume = Math.max(0, volumeIndicator.currentVolume - step)
                }
                
                // Only update if volume actually changed
                if (newVolume !== volumeIndicator.currentVolume) {
                    volumeIndicator.currentVolume = newVolume
                    
                    // Call the Pipewire service to actually change volume
                    try {
                        Pipewire.setSinkVolume(newVolume)
                        console.log("Volume indicator: Changed volume to:", newVolume)
                    } catch (e) {
                        console.log("Volume indicator: Error setting volume:", e.message)
                        // Revert local state if the call failed
                        volumeIndicator.currentVolume = volumeIndicator.currentVolume
                    }
                    
                    // Update shell volume for icon and OSD
                    if (shell) {
                        shell.volume = Math.round(volumeIndicator.currentVolume * 100)
                    }
                }
            } else {
                console.log("Volume indicator: No default sink available for volume control")
            }
        }
    }
}