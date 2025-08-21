import QtQuick
import QtQuick.Layouts
import qs.Settings
import qs.Services

// Network indicator
Rectangle {
    id: networkIndicator
    implicitWidth: text.implicitWidth
    color: "transparent"

    // visible: Network.hasActiveConnection
    
    // Debug logging for network indicator
    Component.onCompleted: {
        console.log("Network indicator: hasActiveConnection =", Network.hasActiveConnection);
        console.log("Network indicator: hasEthernetConnection =", Network.hasEthernetConnection);
        console.log("Network indicator: hasWifiConnection =", Network.hasWifiConnection);
        console.log("Network indicator: networks =", JSON.stringify(Network.networks));
    }
    
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
        
        text: {
            if (Network.hasEthernetConnection) return "lan"
            if (Network.hasWifiConnection) {
                // Find the connected WiFi network to get signal strength
                for (const net in Network.networks) {
                    const network = Network.networks[net]
                    if (network.connected && network.type === "wifi") {
                        return Network.signalIcon(network.signal || 0)
                    }
                }
                return "wifi"
            }
            return "wifi_off"
        }
    }
    
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        
        onEntered: {
            networkIndicator.isHovered = true
        }
        
        onExited: {
            networkIndicator.isHovered = false
        }
        
        onClicked: {
            // Open WiFi settings tab
            SettingsManager.openSettingsTab(0)  // WiFi tab index
        }
    }
}