/*
    SPDX-FileCopyrightText: 2026 Jeysef

    SPDX-License-Identifier: GPL-2.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick

import org.kde.kirigami as Kirigami

import "Calendar.js" as Calendar

// 7x6 grid of square day cells. Cell size and spacing come from
// CalendarView so the day-of-week header shares the exact same columns.
Item {
    id: calendarGrid

    readonly property int columns: 7
    readonly property int rows: 6
    readonly property int cellSize: calendarView.cellSize
    readonly property int spacing: calendarView.cellSpacing

    implicitWidth: columns * cellSize + (columns - 1) * spacing
    implicitHeight: rows * cellSize + (rows - 1) * spacing

    function crossfade() {
        grid.opacity = 0;
        fadeIn.restart();
    }

    Grid {
        id: grid
        anchors.fill: parent
        columns: calendarGrid.columns
        rows: calendarGrid.rows
        spacing: calendarGrid.spacing

        Repeater {
            id: gridRepeater

            model: Calendar.generateMonthGrid(
                calendarView.displayedYear,
                calendarView.displayedMonth,
                root.currentTime,
                calendarView.selectedDate,
                calendarView.firstDayOfWeek)

            delegate: CalendarDayDelegate {
                required property var modelData

                width: calendarGrid.cellSize
                height: calendarGrid.cellSize

                dayData: modelData
                daysModel: calendarView.calendarBackend.daysModel
            }
        }
    }

    NumberAnimation {
        id: fadeIn
        target: grid
        property: "opacity"
        to: 1
        duration: Kirigami.Units.shortDuration
        easing.type: Easing.InOutQuad
    }
}
