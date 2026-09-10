/*
    SPDX-FileCopyrightText: 2013 Sebastian Kügler <sebas@kde.org>
    SPDX-FileCopyrightText: 2014 Martin Gräßlin <mgraesslin@kde.org>
    SPDX-FileCopyrightText: 2016 Kai Uwe Broulik <kde@privat.broulik.de>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick

MouseArea {
    required property /*QModelIndex*/var modelIndex
    required property /*undefined|WId where WId = int|string*/ var winId
    required property Task rootTask

    property bool dragEnabled: false
    property int visualIndex: -1
    property var listView: null
    property var reorderHost: null

    readonly property int dragThreshold: 8

    acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
    hoverEnabled: true
    enabled: winId !== undefined
    cursorShape: dragEnabled
        ? (dragging ? Qt.ClosedHandCursor : Qt.OpenHandCursor)
        : Qt.ArrowCursor
    preventStealing: dragging

    property bool dragging: false
    property bool didDrag: false
    property real pressX: 0
    property real pressY: 0

    function destIndexAt(mouseX, mouseY) {
        const view = listView;
        if (!view || !view.contentItem) {
            return visualIndex;
        }
        const p = mapToItem(view.contentItem, mouseX, mouseY);
        let dest = view.indexAt(p.x, p.y);
        if (dest < 0) {
            if (view.orientation === ListView.Horizontal) {
                dest = p.x < 0 ? 0 : view.count - 1;
            } else {
                dest = p.y < 0 ? 0 : view.count - 1;
            }
        }
        return dest;
    }

    onPressed: (mouse) => {
        dragging = false;
        didDrag = false;
        pressX = mouse.x;
        pressY = mouse.y;
    }

    onPositionChanged: (mouse) => {
        if (!dragEnabled || !(mouse.buttons & Qt.LeftButton) || visualIndex < 0) {
            return;
        }
        if (!dragging) {
            if (Math.abs(mouse.x - pressX) < dragThreshold
                    && Math.abs(mouse.y - pressY) < dragThreshold) {
                return;
            }
            dragging = true;
            didDrag = true;
            if (reorderHost) {
                reorderHost.reordering = true;
            }
            tasks.cancelHighlightWindows();
        }
        const dest = destIndexAt(mouse.x, mouse.y);
        if (dest >= 0 && dest !== visualIndex && listView && listView.moveThumbnail) {
            listView.moveThumbnail(visualIndex, dest);
        }
    }

    onReleased: (mouse) => {
        if (dragging) {
            dragging = false;
            if (reorderHost) {
                reorderHost.reordering = false;
            }
            mouse.accepted = true;
        }
    }

    onCanceled: {
        dragging = false;
        if (reorderHost) {
            reorderHost.reordering = false;
        }
    }

    onClicked: (mouse) => {
        if (didDrag) {
            return;
        }
        switch (mouse.button) {
        case Qt.LeftButton:
            tasksModel.requestActivate(modelIndex);
            rootTask.hideImmediately();
            tasks.cancelHighlightWindows();
            break;
        case Qt.MiddleButton:
            tasks.cancelHighlightWindows();
            tasksModel.requestClose(modelIndex);
            break;
        case Qt.RightButton:
            tasks.createContextMenu(rootTask, modelIndex).show();
            break;
        }
    }

    onContainsMouseChanged: {
        if (!dragging) {
            tasks.windowsHovered([String(winId)], containsMouse);
        }
    }
}
