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

    // Size the popup based on configuration: width is capped at expandedWidth
    // and the height keeps a fixed 340:450 (width:height) aspect ratio.
    implicitWidth: Plasmoid.configuration.expandedWidth
    Layout.preferredWidth: Plasmoid.configuration.expandedWidth
    Layout.maximumWidth: Plasmoid.configuration.expandedWidth
    implicitHeight: Math.round(Plasmoid.configuration.expandedWidth * 450 / 340)
    Layout.preferredHeight: implicitHeight
    Layout.maximumHeight: implicitHeight
    clip: true

    // The popup fill, border and shadow are supplied by the Plasma theme's
    // dialogs/background.svg; we only lay out the content here.
    ColumnLayout {
        id: mainColumn
        anchors {
            fill: parent
            margins: Kirigami.Units.largeSpacing
            bottomMargin: Kirigami.Units.largeSpacing * 2
        }
        spacing: Kirigami.Units.mediumSpacing

        // ── Header: large time (with superscript AM/PM) and full date ──
        ColumnLayout {
            id: headerColumn
            Layout.fillWidth: true
            spacing: Kirigami.Units.smallSpacing / 2

            RowLayout {
                id: timeRow
                Layout.alignment: Qt.AlignHCenter
                spacing: Kirigami.Units.smallSpacing / 2

                PlasmaComponents.Label {
                    id: timeHeader
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    textFormat: Text.PlainText
                    text: {
                        const fmt = root.timeFormat;
                        // Render the AM/PM suffix separately so it can be smaller.
                        if (fmt.toLowerCase().includes("ap")) {
                            return root.displayLocale.toString(root.currentTime, fmt.replace(/\s+AP/i, ""));
                        }
                        return root.displayLocale.toString(root.currentTime, fmt);
                    }
                    color: palette.text
                    font {
                        family: Kirigami.Theme.defaultFont.family
                        weight: Font.DemiBold
                        pixelSize: Kirigami.Units.gridUnit * 1.7
                        features: { "tnum": 1 }
                    }
                }

                PlasmaComponents.Label {
                    id: amPmLabel
                    visible: root.timeFormat.toLowerCase().includes("ap")
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignTop
                    textFormat: Text.PlainText
                    text: root.displayLocale.toString(root.currentTime, "AP")
                    color: palette.text
                    font {
                        family: Kirigami.Theme.defaultFont.family
                        weight: Font.Bold
                        pixelSize: Math.round(timeHeader.font.pixelSize * 0.45)
                    }
                    Layout.alignment: Qt.AlignTop
                    Layout.topMargin: timeHeader.font.pixelSize * 0.12
                }
            }

            PlasmaComponents.Label {
                id: dateHeader
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                textFormat: Text.PlainText
                // Windows 11 omits the year from the date line.
                text: root.displayLocale.toString(root.currentTime, "dddd, MMMM d")
                color: palette.textSecondary
                font {
                    family: Kirigami.Theme.defaultFont.family
                    pixelSize: Math.round(Kirigami.Units.gridUnit * 0.95)
                }
            }
        }

        // ── Calendar grid ──
        CalendarView {
            id: calendarView
            Layout.fillWidth: true
            Layout.fillHeight: true
            focus: true
        }

        // ── Optional timezone list ──
        TimeZoneView {
            id: timeZoneView
            Layout.fillWidth: true
            Layout.preferredHeight: visible ? Kirigami.Units.gridUnit * 8 : 0
            visible: Plasmoid.configuration.selectedTimeZones.length > 1 || Plasmoid.configuration.showLocalTimezone
        }
    }
}
