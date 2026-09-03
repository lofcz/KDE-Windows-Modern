/***************************************************************************
 *   License: GPL-3.0-or-later
 ***************************************************************************/

import QtQuick
import QtQuick.Layouts

import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami

Item {
    id: root

    readonly property bool vertical: (Plasmoid.formFactor == PlasmaCore.Types.Vertical)
    readonly property bool useCustomButtonImage: (Plasmoid.configuration.useCustomButtonImage
                                                  && Plasmoid.configuration.customButtonImage.length != 0)
    readonly property bool menuOpen: dashWindow && dashWindow.dialogVisible
    readonly property bool hovered: mouseArea.containsMouse || menuOpen
    property QtObject dashWindow: null

    // Match Icon Tasks: cell is 91% of the panel strip we now fill.
    readonly property int cellSize: Math.round(Math.max(vertical ? width : height, 1) * 0.91)
    readonly property int iconSize: Math.round(cellSize * 0.58)

    Layout.fillWidth: false
    Layout.fillHeight: !vertical
    Layout.minimumWidth: vertical ? 0 : cellSize
    Layout.preferredWidth: vertical ? -1 : cellSize
    Layout.maximumWidth: vertical ? -1 : cellSize
    Layout.minimumHeight: vertical ? cellSize : 0
    Layout.preferredHeight: vertical ? cellSize : -1
    Layout.maximumHeight: vertical ? cellSize : -1

    implicitWidth: vertical ? 1 : cellSize
    implicitHeight: vertical ? cellSize : 1

    Plasmoid.status: menuOpen ? PlasmaCore.Types.RequiresAttentionStatus : PlasmaCore.Types.PassiveStatus

    Rectangle {
        id: hoverTile
        anchors.centerIn: parent
        width: root.cellSize
        height: root.cellSize
        radius: Math.round(width * 0.22)
        color: "#FFFFFF"
        opacity: root.hovered ? 0.12 : 0
        Behavior on opacity { NumberAnimation { duration: 60 } }
    }

    Image {
        anchors.centerIn: parent
        width: root.iconSize
        height: width
        z: 1
        visible: root.useCustomButtonImage
        source: root.useCustomButtonImage ? Plasmoid.configuration.customButtonImage : ""
        fillMode: Image.PreserveAspectFit
        smooth: true
        antialiasing: true
        asynchronous: false
        sourceSize.width: 128
        sourceSize.height: 128
    }

    Kirigami.Icon {
        anchors.centerIn: parent
        width: root.iconSize
        height: width
        z: 1
        visible: !root.useCustomButtonImage
        source: Plasmoid.configuration.icon
        active: false
        smooth: true
        roundToIconSize: false
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        z: 2
        onClicked: {
            if (dashWindow)
                dashWindow.toggle();
        }
    }

    Component.onCompleted: {
        dashWindow = menuRepComponent.createObject(root);
        if (dashWindow)
            dashWindow.compactButton = root;
        Plasmoid.activated.connect(function() {
            if (dashWindow)
                dashWindow.toggle();
        });
    }

    Component {
        id: menuRepComponent
        MenuRepresentation {}
    }
}
