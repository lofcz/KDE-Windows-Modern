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
    readonly property bool hovered: mouseArea.containsMouse
                                    || (dashWindow && dashWindow.dialogVisible)
    property QtObject dashWindow: null

    // Square cell = panel thickness. Never expand over neighboring tasks.
    Layout.fillWidth: false
    Layout.fillHeight: !vertical
    Layout.minimumWidth: vertical ? 0 : Math.round(Math.max(height, 46) * 0.91)
    Layout.preferredWidth: vertical ? implicitWidth : Math.round(Math.max(height, 46) * 0.91)
    Layout.maximumWidth: vertical ? -1 : Math.round(Math.max(height, 46) * 0.91)

    implicitWidth: 36
    implicitHeight: 46

    Plasmoid.status: dashWindow && dashWindow.dialogVisible ? PlasmaCore.Types.RequiresAttentionStatus : PlasmaCore.Types.PassiveStatus

    // Same Win11 soft tile as Icon Tasks hover.
    Rectangle {
        id: hoverTile
        anchors.centerIn: parent
        width: Math.round(Math.min(parent.width, parent.height) * 0.92)
        height: width
        radius: Math.round(width * 0.22)
        color: "#FFFFFF"
        opacity: root.hovered ? 0.10 : 0
        Behavior on opacity { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }
    }

    Image {
        id: buttonIcon
        anchors.centerIn: parent
        width: Math.round(Math.min(Math.max(root.width, 1), Math.max(root.height, 1)) * 0.82)
        height: width
        z: 1
        visible: root.useCustomButtonImage
        source: root.useCustomButtonImage ? Plasmoid.configuration.customButtonImage : ""
        fillMode: Image.Stretch
        smooth: true
        antialiasing: true
        asynchronous: false
        sourceSize.width: 128
        sourceSize.height: 128
    }

    Kirigami.Icon {
        anchors.centerIn: parent
        width: Math.round(Math.min(Math.max(root.width, 1), Math.max(root.height, 1)) * 0.82)
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
