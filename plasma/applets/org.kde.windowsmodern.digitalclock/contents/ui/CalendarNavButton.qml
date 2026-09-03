/*
    SPDX-FileCopyrightText: 2026 Jeysef

    SPDX-License-Identifier: GPL-2.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick

import org.kde.kirigami as Kirigami

// Small Windows-11-style chevron button used for month navigation.
MouseArea {
    id: root

    property bool up: true

    property color glyphColor: "#FFFFFF"
    property color hoverColor: "#3F3F3F"
    property color pressedColor: "#4A4A4A"

    width: 32
    height: 28

    hoverEnabled: true

    Rectangle {
        anchors.fill: parent
        radius: 4
        color: root.containsPress ? root.pressedColor
                                  : (root.containsMouse ? root.hoverColor : "transparent")

        Behavior on color {
            ColorAnimation {
                duration: Kirigami.Units.shortDuration
                easing.type: Easing.InOutQuad
            }
        }
    }

    Canvas {
        id: glyph
        anchors.centerIn: parent
        width: 12
        height: 8
        opacity: root.containsPress ? 0.6 : 1

        Connections {
            target: root
            function onGlyphColorChanged() { glyph.requestPaint(); }
            function onUpChanged() { glyph.requestPaint(); }
        }

        onPaint: {
            const ctx = getContext("2d");
            ctx.reset();
            ctx.strokeStyle = root.glyphColor;
            ctx.lineWidth = 1.5;
            ctx.lineCap = "round";
            ctx.lineJoin = "round";
            ctx.beginPath();
            if (root.up) {
                ctx.moveTo(1, 6.5);
                ctx.lineTo(6, 1.5);
                ctx.lineTo(11, 6.5);
            } else {
                ctx.moveTo(1, 1.5);
                ctx.lineTo(6, 6.5);
                ctx.lineTo(11, 1.5);
            }
            ctx.stroke();
        }
    }
}
