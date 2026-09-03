/*
    SPDX-FileCopyrightText: 2026 Jeysef

    SPDX-License-Identifier: GPL-2.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.workspace.calendar as PlasmaCalendar
import org.kde.kirigami as Kirigami

import "Calendar.js" as Calendar

// Windows 11 CalendarView: month view with a clickable "Month Year" header
// that zooms out to a year view (12 months) and a decade view (16 years).
// Every level shares the same column grid so headers and cells line up.
ColumnLayout {
    id: calendarView

    Win11Palette { id: palette }

    enum ViewMode { Days, Months, Years }

    // Year/month currently displayed by the calendar (0-based month).
    property int displayedYear: root.currentTime.getFullYear()
    property int displayedMonth: root.currentTime.getMonth()
    property date selectedDate: root.currentTime
    property int viewMode: CalendarView.ViewMode.Days

    readonly property int decadeStart: Math.floor(displayedYear / 10) * 10

    readonly property int firstDayOfWeek: Plasmoid.configuration.firstDayOfWeek > -1
        ? Plasmoid.configuration.firstDayOfWeek
        : root.displayLocale.firstDayOfWeek

    readonly property bool showWeekNumbers: Plasmoid.configuration.showWeekNumbers

    // Width the calendar may use. Supplied by the parent from its own
    // geometry so the cell size never depends on this layout's width (which
    // would make the implicit size self-referential and stall the layout).
    property int availableWidth: 0

    // Shared column geometry (also used by CalendarGrid / week numbers).
    readonly property int cellSpacing: 2
    readonly property int columnCount: showWeekNumbers ? 8 : 7
    readonly property int cellSize: Math.max(28, Math.floor((availableWidth - (columnCount - 1) * cellSpacing) / columnCount))
    readonly property int gridWidth: columnCount * cellSize + (columnCount - 1) * cellSpacing
    readonly property int weekdayRowHeight: 28
    readonly property int gridHeight: 6 * cellSize + 5 * cellSpacing
    // Header text lines up with the centred "Su"/"Mo" labels rather than the cell edge.
    readonly property int headerInset: Math.round(cellSize * 0.25)

    readonly property PlasmaCalendar.EventPluginsManager eventPluginsManager: PlasmaCalendar.EventPluginsManager {
        enabledPlugins: Plasmoid.configuration.enabledCalendarPlugins
    }

    readonly property PlasmaCalendar.Calendar calendarBackend: PlasmaCalendar.Calendar {
        days: 7
        weeks: 6
        firstDayOfWeek: calendarView.firstDayOfWeek
        today: root.currentTime
        displayedDate: new Date(calendarView.displayedYear, calendarView.displayedMonth, 1)

        Component.onCompleted: {
            calendarBackend.daysModel.setPluginsManager(calendarView.eventPluginsManager);
        }
    }

    // First date shown in the 6-week grid.
    readonly property date gridStartDate: {
        const firstDayOfMonth = new Date(calendarView.displayedYear, calendarView.displayedMonth, 1);
        const startDayOfWeek = firstDayOfMonth.getDay();
        let daysFromPreviousMonth = startDayOfWeek - calendarView.firstDayOfWeek;
        if (daysFromPreviousMonth < 0) {
            daysFromPreviousMonth += 7;
        }
        return new Date(calendarView.displayedYear, calendarView.displayedMonth, 1 - daysFromPreviousMonth);
    }

    spacing: 0
    focus: true

    function resetToToday() {
        selectDate(root.currentTime);
        viewMode = CalendarView.ViewMode.Days;
    }

    function selectDate(date) {
        displayedYear = date.getFullYear();
        displayedMonth = date.getMonth();
        selectedDate = date;
    }

    function previousMonth() {
        let newMonth = calendarView.displayedMonth - 1;
        let newYear = calendarView.displayedYear;
        if (newMonth < 0) {
            newMonth = 11;
            newYear--;
        }
        calendarView.displayedMonth = newMonth;
        calendarView.displayedYear = newYear;
    }

    function nextMonth() {
        let newMonth = calendarView.displayedMonth + 1;
        let newYear = calendarView.displayedYear;
        if (newMonth > 11) {
            newMonth = 0;
            newYear++;
        }
        calendarView.displayedMonth = newMonth;
        calendarView.displayedYear = newYear;
    }

    // Chevrons step by month, year or decade depending on the zoom level.
    function navigate(direction) {
        switch (viewMode) {
        case CalendarView.ViewMode.Days:
            if (direction < 0) {
                previousMonth();
            } else {
                nextMonth();
            }
            break;
        case CalendarView.ViewMode.Months:
            displayedYear += direction;
            break;
        case CalendarView.ViewMode.Years:
            displayedYear += 10 * direction;
            break;
        }
    }

    function zoomOut() {
        if (viewMode < CalendarView.ViewMode.Years) {
            viewMode += 1;
        }
    }

    function showMonth(month) {
        displayedMonth = month;
        viewMode = CalendarView.ViewMode.Days;
    }

    function showYear(year) {
        displayedYear = year;
        viewMode = CalendarView.ViewMode.Months;
    }

    onDisplayedMonthChanged: calendarGrid.crossfade()
    onDisplayedYearChanged: {
        calendarGrid.crossfade();
        zoomHost.crossfade();
    }
    onViewModeChanged: zoomHost.zoom()

    Keys.onPressed: event => {
        if (calendarView.viewMode !== CalendarView.ViewMode.Days) {
            switch (event.key) {
            case Qt.Key_Escape:
            case Qt.Key_Home:
                calendarView.resetToToday();
                event.accepted = true;
                break;
            case Qt.Key_PageUp:
                calendarView.navigate(-1);
                event.accepted = true;
                break;
            case Qt.Key_PageDown:
                calendarView.navigate(1);
                event.accepted = true;
                break;
            }
            return;
        }
        const d = new Date(calendarView.selectedDate);
        switch (event.key) {
        case Qt.Key_Left:
            d.setDate(d.getDate() - 1);
            calendarView.selectDate(d);
            event.accepted = true;
            break;
        case Qt.Key_Right:
            d.setDate(d.getDate() + 1);
            calendarView.selectDate(d);
            event.accepted = true;
            break;
        case Qt.Key_Up:
            d.setDate(d.getDate() - 7);
            calendarView.selectDate(d);
            event.accepted = true;
            break;
        case Qt.Key_Down:
            d.setDate(d.getDate() + 7);
            calendarView.selectDate(d);
            event.accepted = true;
            break;
        case Qt.Key_Home:
            calendarView.resetToToday();
            event.accepted = true;
            break;
        case Qt.Key_PageUp:
            calendarView.previousMonth();
            event.accepted = true;
            break;
        case Qt.Key_PageDown:
            calendarView.nextMonth();
            event.accepted = true;
            break;
        }
    }

    // ── Header: zoom button + chevrons ──
    Item {
        Layout.alignment: Qt.AlignHCenter
        Layout.preferredWidth: calendarView.gridWidth
        Layout.preferredHeight: 36

        MouseArea {
            id: headerButton
            anchors {
                left: parent.left
                // Keep the text where it was; the hover pill extends 8 px around it.
                leftMargin: calendarView.headerInset - 8
                verticalCenter: parent.verticalCenter
            }
            width: Math.min(headerLabel.implicitWidth + 16, navButtons.x - x - 4)
            height: 28
            hoverEnabled: true
            enabled: calendarView.viewMode !== CalendarView.ViewMode.Years
            onClicked: calendarView.zoomOut()
            Accessible.role: Accessible.Button
            Accessible.name: headerLabel.text

            Rectangle {
                anchors.fill: parent
                radius: 4
                color: headerButton.containsPress ? palette.pressed
                     : (headerButton.containsMouse && headerButton.enabled ? palette.hover : "transparent")

                Behavior on color {
                    ColorAnimation { duration: Kirigami.Units.shortDuration; easing.type: Easing.InOutQuad }
                }
            }

            PlasmaComponents.Label {
                id: headerLabel
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: 8
                    rightMargin: 8
                    verticalCenter: parent.verticalCenter
                }
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
                textFormat: Text.PlainText
                text: {
                    switch (calendarView.viewMode) {
                    case CalendarView.ViewMode.Months:
                        return String(calendarView.displayedYear);
                    case CalendarView.ViewMode.Years:
                        return calendarView.decadeStart + " – " + (calendarView.decadeStart + 9);
                    default:
                        return root.displayLocale.standaloneMonthName(calendarView.displayedMonth, Locale.LongFormat)
                               + " " + calendarView.displayedYear;
                    }
                }
                color: headerButton.containsPress ? palette.textSecondary : palette.text
                font {
                    family: Kirigami.Theme.defaultFont.family
                    weight: Font.DemiBold
                    pixelSize: 14
                }
            }
        }

        Row {
            id: navButtons
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
            spacing: 4

            CalendarNavButton {
                up: true
                glyphColor: palette.text
                hoverColor: palette.hover
                pressedColor: palette.pressed
                onClicked: calendarView.navigate(-1)
                Accessible.name: i18n("Previous")
            }

            CalendarNavButton {
                up: false
                glyphColor: palette.text
                hoverColor: palette.hover
                pressedColor: palette.pressed
                onClicked: calendarView.navigate(1)
                Accessible.name: i18n("Next")
            }
        }
    }

    // ── Body: day / month / year views, all the same size ──
    Item {
        id: zoomHost
        Layout.alignment: Qt.AlignHCenter
        Layout.preferredWidth: calendarView.gridWidth
        Layout.preferredHeight: calendarView.weekdayRowHeight + calendarView.gridHeight
        clip: true

        function zoom() {
            zoomAnimation.restart();
        }

        function crossfade() {
            if (calendarView.viewMode !== CalendarView.ViewMode.Days) {
                fadeAnimation.restart();
            }
        }

        ParallelAnimation {
            id: zoomAnimation
            NumberAnimation {
                target: zoomHost; property: "opacity"; from: 0; to: 1
                duration: Kirigami.Units.longDuration; easing.type: Easing.OutCubic
            }
            NumberAnimation {
                target: zoomHost; property: "scale"; from: 0.94; to: 1
                duration: Kirigami.Units.longDuration; easing.type: Easing.OutCubic
            }
        }

        NumberAnimation {
            id: fadeAnimation
            target: zoomHost; property: "opacity"; from: 0; to: 1
            duration: Kirigami.Units.shortDuration; easing.type: Easing.InOutQuad
        }

        // Scroll wheel navigates at the current zoom level.
        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.NoButton
            onWheel: wheel => {
                calendarView.navigate(wheel.angleDelta.y > 0 ? -1 : 1);
                wheel.accepted = true;
            }
        }

        // Month view: day-of-week row + 6-week grid.
        Column {
            anchors.fill: parent
            visible: calendarView.viewMode === CalendarView.ViewMode.Days
            spacing: 0

            Row {
                width: parent.width
                height: calendarView.weekdayRowHeight
                spacing: calendarView.cellSpacing

                Item {
                    visible: calendarView.showWeekNumbers
                    width: calendarView.cellSize
                    height: parent.height

                    PlasmaComponents.Label {
                        anchors.centerIn: parent
                        textFormat: Text.PlainText
                        text: i18nc("@label week number column header", "Wk")
                        color: palette.textSecondary
                        font {
                            family: Kirigami.Theme.defaultFont.family
                            pixelSize: 12
                        }
                    }
                }

                Repeater {
                    model: 7
                    delegate: Item {
                        required property int index
                        width: calendarView.cellSize
                        height: parent.height

                        PlasmaComponents.Label {
                            anchors.centerIn: parent
                            textFormat: Text.PlainText
                            // Windows 11 uses two-letter day names ("Su", "Mo", ...).
                            text: root.displayLocale.standaloneDayName((calendarView.firstDayOfWeek + index) % 7, Locale.ShortFormat).substring(0, 2)
                            color: palette.textSecondary
                            font {
                                family: Kirigami.Theme.defaultFont.family
                                pixelSize: 12
                            }
                        }
                    }
                }
            }

            Row {
                width: parent.width
                height: calendarView.gridHeight
                spacing: calendarView.cellSpacing

                Column {
                    visible: calendarView.showWeekNumbers
                    spacing: calendarView.cellSpacing

                    Repeater {
                        model: 6
                        delegate: Item {
                            required property int index
                            width: calendarView.cellSize
                            height: calendarView.cellSize

                            PlasmaComponents.Label {
                                anchors.centerIn: parent
                                textFormat: Text.PlainText
                                text: Calendar.isoWeekNumber(new Date(calendarView.gridStartDate.getTime() + index * 7 * 86400000))
                                color: palette.textSecondary
                                font {
                                    family: Kirigami.Theme.defaultFont.family
                                    pixelSize: 12
                                    features: { "tnum": 1 }
                                }
                            }
                        }
                    }
                }

                CalendarGrid {
                    id: calendarGrid
                }
            }
        }

        // Year view: 12 months, 4 x 3.
        Grid {
            anchors.fill: parent
            visible: calendarView.viewMode === CalendarView.ViewMode.Months
            columns: 4
            rows: 3
            spacing: 4

            Repeater {
                model: 12
                delegate: CalendarZoomItem {
                    required property int index
                    width: Math.floor((zoomHost.width - 3 * 4) / 4)
                    height: Math.floor((zoomHost.height - 2 * 4) / 3)
                    text: root.displayLocale.standaloneMonthName(index, Locale.ShortFormat)
                    isCurrent: index === root.currentTime.getMonth()
                        && calendarView.displayedYear === root.currentTime.getFullYear()
                    onClicked: calendarView.showMonth(index)
                }
            }
        }

        // Decade view: 16 years, 4 x 4; years outside the decade are dimmed.
        Grid {
            anchors.fill: parent
            visible: calendarView.viewMode === CalendarView.ViewMode.Years
            columns: 4
            rows: 4
            spacing: 4

            Repeater {
                model: 16
                delegate: CalendarZoomItem {
                    required property int index
                    readonly property int year: calendarView.decadeStart + index
                    width: Math.floor((zoomHost.width - 3 * 4) / 4)
                    height: Math.floor((zoomHost.height - 3 * 4) / 4)
                    text: String(year)
                    isCurrent: year === root.currentTime.getFullYear()
                    dimmed: index > 9
                    onClicked: calendarView.showYear(year)
                }
            }
        }
    }
}
