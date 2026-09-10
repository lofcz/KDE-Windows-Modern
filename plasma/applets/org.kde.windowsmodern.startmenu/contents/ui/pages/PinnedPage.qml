/***************************************************************************
 *   License: GPL-3.0-or-later
 *
 *   Windows 11 pinned page: a grid of favorite app tiles.
 ***************************************************************************/

import QtQuick
import QtQuick.Layouts

import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents3
import org.kde.kirigami as Kirigami

import "../components"

ColumnLayout {
    id: pinnedPage

    spacing: Kirigami.Units.largeSpacing

    property alias favoritesList: favoritesGrid

    readonly property int columns: Math.max(4, Plasmoid.configuration.numberColumns)

    signal showAllAppsRequested
    signal keyNavUpFromList

    function tryActivate(row) {
        if (favoritesGrid.count > 0) {
            favoritesGrid.currentIndex = Math.min(row, favoritesGrid.count - 1);
        }
    }

    function navigateUp() {
        if (favoritesGrid.count > 0) {
            favoritesGrid.currentIndex = Math.max(0, favoritesGrid.currentIndex - pinnedPage.columns);
        }
    }

    function navigateDown() {
        if (favoritesGrid.count > 0) {
            favoritesGrid.currentIndex = Math.min(favoritesGrid.count - 1, favoritesGrid.currentIndex + pinnedPage.columns);
        }
    }

    function activateCurrent() {
        if (favoritesGrid.currentIndex >= 0 && favoritesGrid.model) {
            favoritesGrid.model.trigger(favoritesGrid.currentIndex, "", null);
            root.closeMenu();
        }
    }

    RowLayout {
        id: headerRow
        Layout.fillWidth: true
        spacing: Kirigami.Units.smallSpacing

        PlasmaComponents3.Label {
            text: i18n("Pinned")
            color: Kirigami.Theme.textColor
            font.pixelSize: Math.round(Kirigami.Theme.defaultFont.pixelSize * 1.15)
            font.weight: Font.DemiBold
            Layout.alignment: Qt.AlignVCenter
        }

        Item { Layout.fillWidth: true }

        AToolButton {
            buttonHeight: 24
            iconName: "go-next"
            text: i18n("All apps")
            onClicked: pinnedPage.showAllAppsRequested()
        }
    }

    GridView {
        id: favoritesGrid
        Layout.fillWidth: true
        Layout.fillHeight: true
        clip: true
        interactive: contentHeight > height
        boundsBehavior: Flickable.StopAtBounds
        currentIndex: -1
        cellWidth: Math.floor(width / pinnedPage.columns)
        cellHeight: Math.round(Kirigami.Units.iconSizes.large * 0.9
                               + Kirigami.Theme.defaultFont.pixelSize * 2.4
                               + Kirigami.Units.largeSpacing)

        delegate: PinnedTile {}

        highlightMoveDuration: 0

        // Hover is tracked on the view, not the delegate. Delegate MouseAreas
        // and Flickable steal HoverHandler/containsMouse inside Plasma dialogs.
        HoverHandler {
            id: gridHover
            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
            onPointChanged: {
                const p = point.position;
                const idx = favoritesGrid.indexAt(p.x + favoritesGrid.contentX,
                                                  p.y + favoritesGrid.contentY);
                favoritesGrid.currentIndex = idx;
            }
            onHoveredChanged: {
                if (!hovered)
                    favoritesGrid.currentIndex = -1;
            }
        }

        Keys.onLeftPressed: event => {
            if (currentIndex > 0) {
                currentIndex--;
                event.accepted = true;
            }
        }
        Keys.onRightPressed: event => {
            if (currentIndex < count - 1) {
                currentIndex++;
                event.accepted = true;
            }
        }
        Keys.onUpPressed: event => {
            if (currentIndex < pinnedPage.columns) {
                event.accepted = true;
                pinnedPage.keyNavUpFromList();
            } else {
                currentIndex -= pinnedPage.columns;
                event.accepted = true;
            }
        }
        Keys.onDownPressed: event => {
            currentIndex = Math.min(count - 1, currentIndex + pinnedPage.columns);
            event.accepted = true;
        }
    }
}
