/*
    SPDX-FileCopyrightText: 2026 Jeysef

    SPDX-License-Identifier: GPL-2.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick

import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami

// A month (year view) or year (decade view) tile. Windows 11 draws these as
// rounded rectangles; the current month/year is filled with the accent.
MouseArea {
    id: item

    property string text
    property bool isCurrent: false
    property bool dimmed: false

    Win11Palette { id: palette }

    hoverEnabled: true

    Accessible.role: Accessible.Button
    Accessible.name: text

    Rectangle {
        anchors.fill: parent
        anchors.margins: 2
        radius: 4
        color: {
            if (item.isCurrent) {
                if (item.containsPress) {
                    return Qt.alpha(palette.accent, 0.8);
                }
                return item.containsMouse ? Qt.alpha(palette.accent, 0.9) : palette.accent;
            }
            if (item.containsPress) {
                return palette.pressed;
            }
            if (item.containsMouse) {
                return palette.hover;
            }
            return "transparent";
        }

        Behavior on color {
            ColorAnimation {
                duration: Kirigami.Units.shortDuration
                easing.type: Easing.InOutQuad
            }
        }
    }

    PlasmaComponents.Label {
        anchors.centerIn: parent
        textFormat: Text.PlainText
        text: item.text
        color: {
            if (item.isCurrent) {
                return palette.accentText;
            }
            return item.dimmed ? palette.textSecondary : palette.text;
        }
        font {
            family: Kirigami.Theme.defaultFont.family
            pixelSize: 14
            weight: item.isCurrent ? Font.DemiBold : Font.Normal
            features: { "tnum": 1 }
        }
    }
}
