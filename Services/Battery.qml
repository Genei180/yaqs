import QtQuick
import Quickshell
import Quickshell.Services.UPower

Scope {
    id: batteryService

    UPower {
        id: upower
    }

    // Query the primary battery once
    property UPowerDevice battery: upower.device(upower.primaryBattery)

    // Exported data
    readonly property int percentage: battery ? Math.round(battery.percentage) : 0
    readonly property bool charging: battery && battery.state === UPowerDevice.Charging
    readonly property bool full: battery && battery.state === UPowerDevice.Full

    // readonly property string icon: {
    //     if (!battery) return "battery_unknown"
    //     if (full) return "battery_full"
    //     if (charging) return "battery_charging_full"

    //     if (percentage > 80) return "battery_6_bar"
    //     if (percentage > 60) return "battery_5_bar"
    //     if (percentage > 40) return "battery_4_bar"
    //     if (percentage > 20) return "battery_2_bar"
    //     return "battery_alert"
    // }
}
