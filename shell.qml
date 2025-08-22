//@ pragma UseQApplication

import QtQuick
import Quickshell
import "./modules/bar/top/"
import "./modules/bar/right/"

ShellRoot {
    id: root

    Loader {
        active: true
        sourceComponent: TopBar{}
    }

    Loader {
        active: true
        sourceComponent: RightBar{}
    }
}