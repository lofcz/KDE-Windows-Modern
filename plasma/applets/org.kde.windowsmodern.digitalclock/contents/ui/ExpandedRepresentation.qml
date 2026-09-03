/*
    SPDX-FileCopyrightText: 2026 Jeysef

    SPDX-License-Identifier: GPL-2.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami

Item {
    id: expandedRoot

    Win11Palette { id: palette }

    readonly property int padding: 16

    // Width comes from configuration; height follows the content so there is
    // no dead space below the calendar grid. Minimum and maximum are pinned
    // to the same values so a stale user-resized popup size (popupWidth/
    // popupHeight in the applet config) cannot override them.
    implicitWidth: Plasmoid.configuration.expandedWidth
    Layout.minimumWidth: Plasmoid.configuration.expandedWidth
    Layout.preferredWidth: Plasmoid.configuration.expandedWidth
    Layout.maximumWidth: Plasmoid.configuration.expandedWidth
    implicitHeight: mainColumn.implicitHeight + padding * 2
    Layout.minimumHeight: implicitHeight
    Layout.preferredHeight: implicitHeight
    Layout.maximumHeight: implicitHeight
    clip: true

    readonly property int contentWidth: Math.max(0, width - padding * 2)

    // The popup item stays alive while hidden, so jump back to today (and the
    // month view) every time the flyout is opened.
    Connections {
        target: root
        function onExpandedChanged(): void {
            if (root.expanded) {
                calendarView.resetToToday();
            }
        }
    }

    // The popup fill, border and shadow are supplied by the Plasma theme's
    // dialogs/background.svg; we only lay out the content here.
    ColumnLayout {
        id: mainColumn
        anchors {
            fill: parent
            margins: expandedRoot.padding
        }
        spacing: 0

        // ── Header: time (with superscript AM/PM) and full date, aligned with the grid ──
        ColumnLayout {
            id: headerColumn
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: calendarView.gridWidth
            Layout.bottomMargin: 8
            spacing: 0

            RowLayout {
                id: timeRow
                Layout.leftMargin: calendarView.headerInset
                spacing: 3

                PlasmaComponents.Label {
                    id: timeHeader
                    verticalAlignment: Text.AlignVCenter
                    textFormat: Text.PlainText
                    text: {
                        // Format with the full pattern (so "h" stays 12-hour when the
                        // pattern has AP) and drop the AM/PM token from the result; it
                        // is rendered separately as a smaller superscript.
                        const full = root.displayLocale.toString(root.currentTime, root.timeFormat);
                        if (!root.timeFormat.toLowerCase().includes("ap")) {
                            return full;
                        }
                        const ap = root.displayLocale.toString(root.currentTime, "AP");
                        return full.replace(ap, "").trim();
                    }
                    color: palette.text
                    font {
                        family: Kirigami.Theme.defaultFont.family
                        weight: Font.DemiBold
                        pixelSize: 28
                        features: { "tnum": 1 }
                    }
                }

                PlasmaComponents.Label {
                    id: amPmLabel
                    visible: root.timeFormat.toLowerCase().includes("ap")
                    Layout.alignment: Qt.AlignTop
                    Layout.topMargin: 5
                    textFormat: Text.PlainText
                    text: root.displayLocale.toString(root.currentTime, "AP")
                    color: palette.text
                    font {
                        family: Kirigami.Theme.defaultFont.family
                        weight: Font.Bold
                        pixelSize: 12
                    }
                }
            }

            PlasmaComponents.Label {
                id: dateHeader
                Layout.fillWidth: true
                Layout.leftMargin: calendarView.headerInset
                elide: Text.ElideRight
                textFormat: Text.PlainText
                // Windows 11 omits the year from the date line.
                text: root.displayLocale.toString(root.currentTime, "dddd, MMMM d")
                color: palette.textSecondary
                font {
                    family: Kirigami.Theme.defaultFont.family
                    pixelSize: 14
                }
            }
        }

        // ── Calendar ──
        CalendarView {
            id: calendarView
            Layout.fillWidth: true
            availableWidth: expandedRoot.contentWidth
            focus: true
        }

        // ── Optional timezone list ──
        TimeZoneView {
            id: timeZoneView
            Layout.fillWidth: true
            Layout.topMargin: visible ? 12 : 0
            Layout.preferredHeight: visible ? Kirigami.Units.gridUnit * 8 : 0
            visible: Plasmoid.configuration.selectedTimeZones.length > 1 || Plasmoid.configuration.showLocalTimezone
        }
    }
}
