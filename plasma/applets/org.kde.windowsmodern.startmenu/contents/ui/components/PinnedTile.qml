/***************************************************************************
 *   License: GPL-3.0-or-later
 *
 *   Windows 11 pinned tile: icon above a two-line name.
 ***************************************************************************/

import QtQuick
import QtQuick.Layouts

import org.kde.plasma.components as PlasmaComponents3
import org.kde.kirigami as Kirigami

import "../code/tools.js" as Tools
import "../code/theme.js" as Theme

Item {
    id: tile

    required property int index
    required property var model

    width: GridView.view ? GridView.view.cellWidth : parent.width
    height: GridView.view ? GridView.view.cellHeight : parent.height

    readonly property int itemIndex: model.index !== undefined ? model.index : index
    readonly property int glyphSize: Math.round(Kirigami.Units.iconSizes.large * 0.9)
    readonly property bool highlighted: tile.GridView.isCurrentItem

    Accessible.role: Accessible.Button
    Accessible.name: model.display !== undefined ? model.display : ""

    Rectangle {
        id: hoverBackground
        anchors.fill: parent
        anchors.margins: 4
        radius: 8
        color: "#FFFFFF"
        opacity: tile.highlighted ? 0.12 : 0
        Behavior on opacity { NumberAnimation { duration: 60 } }
    }

    ColumnLayout {
        id: contentCol
        anchors.centerIn: parent
        width: tile.width - 12
        spacing: 4

        Kirigami.Icon {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: tile.glyphSize
            Layout.preferredHeight: tile.glyphSize
            animated: false
            source: model.decoration !== undefined ? model.decoration : ""
        }

        PlasmaComponents3.Label {
            id: nameLabel
            Layout.fillWidth: true
            Layout.preferredHeight: implicitHeight
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignTop
            wrapMode: Text.WordWrap
            maximumLineCount: 2
            elide: Text.ElideRight
            color: Kirigami.Theme.textColor
            font.pixelSize: Kirigami.Theme.defaultFont.pixelSize
            text: ("name" in model ? model.name : (model.display !== undefined ? model.display : ""))
            textFormat: Text.PlainText
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: false
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        cursorShape: Qt.PointingHandCursor
        onClicked: mouse => {
            var view = tile.GridView.view;
            if (view)
                view.currentIndex = tile.itemIndex;
            if (mouse.button === Qt.RightButton) {
                tile.openContextMenu(mouse.x, mouse.y);
                return;
            }
            tile.launchApp();
        }
    }

    function launchApp() {
        var view = tile.GridView.view;
        if (view && view.model && typeof view.model.trigger === "function") {
            view.model.trigger(tile.itemIndex, "", null);
            root.closeMenu();
        }
    }

    function openContextMenu(localX, localY) {
        var favModel = (typeof kicker !== "undefined" && kicker.globalFavorites)
                       ? kicker.globalFavorites : null;
        var favId = (model.favoriteId !== undefined) ? model.favoriteId : "";
        var url = (model.url !== undefined) ? model.url : "";
        var actionList = (model.actionList !== undefined) ? model.actionList : null;
        var acts = Tools.buildAppActions(i18n, favModel, favId, url, actionList);
        if (acts.length === 0)
            return;
        var pos = tile.mapToItem(sharedContextMenu, localX, localY);
        var view = tile.GridView.view;
        sharedContextMenu.open(acts, pos.x, pos.y, {
            model: view ? view.model : null,
            index: tile.itemIndex
        });
    }
}
