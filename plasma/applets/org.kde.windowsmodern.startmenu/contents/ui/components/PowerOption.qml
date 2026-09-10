/***************************************************************************
 *   License: GPL-3.0-or-later
 *   Author: Jeysef
 *
 *   Windows 11 flyout row: icon + label, muted hover fill.
 ***************************************************************************/

import QtQuick
import QtQuick.Layouts

import org.kde.plasma.components as PlasmaComponents3
import org.kde.kirigami as Kirigami

Item {
    id: option

    property string iconSource
    property string label
    property bool optionEnabled: true

    signal activated

    width: parent ? parent.width : Kirigami.Units.gridUnit * 11
    height: 36

    Rectangle {
        anchors.fill: parent
        anchors.leftMargin: 4
        anchors.rightMargin: 4
        anchors.topMargin: 1
        anchors.bottomMargin: 1
        radius: 4
        color: option.optionEnabled && hoverArea.containsMouse ? "#3F3F3F" : "transparent"
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 14
        anchors.rightMargin: 12
        spacing: 12

        Kirigami.Icon {
            Layout.preferredWidth: 16
            Layout.preferredHeight: 16
            source: option.iconSource
            color: option.optionEnabled ? "#FFFFFF" : "#5A5A5A"
        }

        PlasmaComponents3.Label {
            Layout.fillWidth: true
            text: option.label
            color: option.optionEnabled ? "#FFFFFF" : "#5A5A5A"
            font.family: "Segoe UI"
            font.pointSize: 10
            elide: Text.ElideRight
        }
    }

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: option.optionEnabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        enabled: option.optionEnabled
        onClicked: option.activated()
    }
}
