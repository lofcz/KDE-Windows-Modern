/***************************************************************************
 *   License: GPL-3.0-or-later
 *
 *   Windows 11 Start "All apps" / "Back" chip: no outline, soft fill,
 *   small chevron. Hover only lifts the fill.
 ***************************************************************************/

import QtQuick
import QtQuick.Layouts

import org.kde.kirigami as Kirigami

Item {
    id: item

    property int buttonHeight: 24
    property alias text: label.text
    property bool flat: true
    property alias iconName: chevron.source
    property bool mirror: false

    signal clicked

    implicitHeight: buttonHeight
    implicitWidth: row.implicitWidth + 20
    focus: true

    Keys.onSpacePressed: item.clicked()
    Keys.onReturnPressed: item.clicked()

    Rectangle {
        anchors.fill: parent
        radius: 4
        border.width: 0
        color: mouseItem.pressed
               ? Qt.rgba(1, 1, 1, 0.16)
               : mouseItem.containsMouse
                 ? Qt.rgba(1, 1, 1, 0.12)
                 : Qt.rgba(1, 1, 1, 0.06)
        Behavior on color { ColorAnimation { duration: 80 } }
    }

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 6
        layoutDirection: item.mirror ? Qt.RightToLeft : Qt.LeftToRight

        Text {
            id: label
            color: Kirigami.Theme.textColor
            font.pixelSize: Math.round(Kirigami.Theme.defaultFont.pixelSize * 0.92)
            font.weight: Font.Normal
            verticalAlignment: Text.AlignVCenter
        }

        Kirigami.Icon {
            id: chevron
            Layout.preferredWidth: 10
            Layout.preferredHeight: 10
            color: Kirigami.Theme.textColor
            opacity: 0.85
            smooth: true
        }
    }

    MouseArea {
        id: mouseItem
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: item.clicked()
    }
}
