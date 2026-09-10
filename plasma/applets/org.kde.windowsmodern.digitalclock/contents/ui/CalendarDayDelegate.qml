/*
    SPDX-FileCopyrightText: 2026 Jeysef

    SPDX-License-Identifier: GPL-2.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls as QQC2

import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.workspace.calendar as PlasmaCalendar
import org.kde.kirigami as Kirigami

// One day cell. Windows 11 CalendarView day items are circular in every
// state: today is a filled accent circle, the selected day an accent ring,
// hover/press a subtle translucent circle.
MouseArea {
    id: dayDelegate

    required property var dayData
    required property PlasmaCalendar.DaysModel daysModel

    Win11Palette { id: palette }

    hoverEnabled: true

    // Events for this day, queried from the shared DaysModel.
    readonly property var dayEvents: daysModel ? daysModel.eventsForDate(dayData.date) : []
    readonly property bool hasEvents: dayEvents && dayEvents.length > 0

    Accessible.role: Accessible.Button
    Accessible.name: dayData.day
        + (dayData.isToday ? i18n(", today") : "")
        + (dayData.isSelected ? i18n(", selected") : "")

    onClicked: {
        calendarView.selectDate(dayData.date);
    }

    Rectangle {
        id: dayBackground
        anchors.centerIn: parent
        width: Math.min(parent.width, parent.height) - 2
        height: width
        radius: width / 2
        color: {
            if (dayData.isToday) {
                if (dayDelegate.containsPress) {
                    return Qt.alpha(palette.accent, 0.8);
                }
                return dayDelegate.containsMouse ? Qt.alpha(palette.accent, 0.9) : palette.accent;
            }
            if (dayDelegate.containsPress) {
                return palette.pressed;
            }
            if (dayDelegate.containsMouse) {
                return palette.hover;
            }
            return "transparent";
        }
        border.color: dayData.isSelected && !dayData.isToday ? palette.accent : "transparent"
        border.width: 2

        Behavior on color {
            ColorAnimation {
                duration: Kirigami.Units.shortDuration
                easing.type: Easing.InOutQuad
            }
        }
    }

    PlasmaComponents.Label {
        id: dayLabel
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        textFormat: Text.PlainText
        text: dayData.day
        color: {
            if (dayData.isToday) {
                return palette.accentText;
            }
            if (dayData.isCurrentMonth) {
                return palette.text;
            }
            return palette.textSecondary;
        }
        font {
            family: Kirigami.Theme.defaultFont.family
            pixelSize: 14
            weight: dayData.isToday ? Font.DemiBold : Font.Normal
            features: { "tnum": 1 }
        }
    }

    // Event dots sit inside the circle below the number without moving it.
    Row {
        id: eventDotsRow
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: dayBackground.bottom
        anchors.bottomMargin: 5
        visible: dayDelegate.hasEvents
        spacing: 2

        Repeater {
            model: Math.min(3, dayDelegate.dayEvents.length)
            delegate: Rectangle {
                required property int index
                width: 3
                height: 3
                radius: 1.5
                color: dayData.isToday
                    ? palette.accentText
                    : (dayDelegate.dayEvents[index].eventColor || palette.accent)
            }
        }
    }

    QQC2.ToolTip {
        visible: dayDelegate.hasEvents && dayDelegate.containsMouse
        text: dayDelegate.dayEvents.map(ev => ev.summary || "").join("\n")
        delay: 800
    }
}
