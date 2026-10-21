/* SPDX-License-Identifier: GPL-3.0-or-later */
import QtQuick
import QtQuick.Layouts
import org.kde.plasma.components as PlasmaComponents3
import org.kde.kirigami as Kirigami

Item {
    id: tile
    required property int index
    required property var pin
    required property var page
    property string containerId: ""
    property bool selected: GridView.isCurrentItem
    readonly property int glyphSize: Math.round(Kirigami.Units.iconSizes.large * 0.9)
    readonly property bool isFolder: pin.type === "folder"
    readonly property string title: pin.name || (isFolder ? qsTr("Folder") : "")
    readonly property string dropMode: page.dragging && page.targetId === pin.id
                                       && page.targetFolder === containerId ? page.dropMode : ""
    readonly property bool sourceDragging: page.dragging && page.dragId === pin.id
    objectName: "pinTile:" + containerId + ":" + pin.id
    width: GridView.view ? GridView.view.cellWidth : 100
    height: GridView.view ? GridView.view.cellHeight : 100
    opacity: sourceDragging ? 0.35 : 1

    Accessible.role: Accessible.Button
    Accessible.name: title
    Accessible.onPressAction: page.activate(pin)

    Rectangle {
        anchors.fill: parent
        anchors.margins: 4
        radius: 8
        color: tile.dropMode === "inside" ? Kirigami.Theme.highlightColor : "#FFFFFF"
        opacity: tile.dropMode === "inside" ? 0.25 : (tile.selected ? 0.12 : 0)
        border.width: tile.dropMode === "inside" ? 2 : 0
        border.color: Kirigami.Theme.highlightColor
        Behavior on opacity { NumberAnimation { duration: 60 } }
    }
    Rectangle {
        visible: tile.dropMode === "before" || tile.dropMode === "after"
        x: tile.dropMode === "after" ? parent.width - width : 0
        y: 6
        width: 3
        height: parent.height - 12
        radius: 1
        color: Kirigami.Theme.highlightColor
    }

    ColumnLayout {
        anchors.centerIn: parent
        width: tile.width - 12
        spacing: 4
        Item {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: tile.glyphSize
            Layout.preferredHeight: tile.glyphSize
            scale: tile.dropMode === "inside" ? 0.86 : 1
            Behavior on scale { NumberAnimation { duration: 100 } }
            Kirigami.Icon {
                anchors.fill: parent
                visible: !tile.isFolder
                animated: false
                source: tile.pin.icon ?? "application-x-executable"
            }
            Rectangle {
                anchors.fill: parent
                visible: tile.isFolder
                color: Qt.rgba(1, 1, 1, 0.08)
                border.color: Qt.rgba(1, 1, 1, 0.14)
                radius: 7
                Grid {
                    anchors.centerIn: parent
                    columns: 2
                    spacing: 3
                    Repeater {
                        model: tile.isFolder ? tile.pin.items.slice(0, 4) : []
                        Kirigami.Icon {
                            required property var modelData
                            width: Math.floor((tile.glyphSize - 13) / 2)
                            height: width
                            animated: false
                            source: modelData.icon
                        }
                    }
                }
            }
        }
        PlasmaComponents3.Label {
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            maximumLineCount: 2
            elide: Text.ElideRight
            color: Kirigami.Theme.textColor
            font.pixelSize: Kirigami.Theme.defaultFont.pixelSize
            text: tile.title
            textFormat: Text.PlainText
        }
    }

    // Move a separate anchor: GridView retains ownership of tile geometry.
    // The page draws the drag ghost above both grids and the folder panel.
    Item { id: dragAnchor; width: 1; height: 1 }
    MouseArea {
        id: pointer
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        cursorShape: dragged ? Qt.ClosedHandCursor : Qt.PointingHandCursor
        preventStealing: true
        property bool dragged: false
        drag.target: dragAnchor
        onPressed: {
            dragged = false;
            dragAnchor.x = 0;
            dragAnchor.y = 0;
        }
        onPositionChanged: mouse => {
            if (!drag.active) return;
            if (!dragged) {
                dragged = true;
                tile.page.beginDrag(tile.pin, tile.containerId);
            }
            const point = tile.mapToItem(tile.page, mouse.x, mouse.y);
            tile.page.updateDrag(point.x, point.y);
        }
        onReleased: {
            if (dragged) tile.page.finishDrag();
        }
        onCanceled: {
            if (dragged) tile.page.cancelDrag();
        }
        onClicked: mouse => {
            if (dragged) return;
            if (tile.GridView.view) tile.GridView.view.currentIndex = tile.index;
            if (mouse.button === Qt.RightButton) {
                const point = tile.mapToItem(tile.page, mouse.x, mouse.y);
                tile.page.openPinContext(tile.pin, tile.containerId, point.x, point.y);
            } else tile.page.activate(tile.pin);
        }
    }
}
