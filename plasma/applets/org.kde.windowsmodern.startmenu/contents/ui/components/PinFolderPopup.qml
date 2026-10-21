/* SPDX-License-Identifier: GPL-3.0-or-later */
import QtQuick
import QtQuick.Layouts
import org.kde.plasma.components as PlasmaComponents3
import org.kde.kirigami as Kirigami

Item {
    id: popup
    required property var page
    property var folder: null
    readonly property alias grid: folderGrid
    readonly property alias card: card
    anchors.fill: parent
    visible: folder !== null
    z: 90

    onFolderChanged: {
        if (folder && !folderName.activeFocus) folderName.text = folder.name;
    }

    function saveName() {
        if (folder && folderName.text.trim() !== folder.name) page.renameFolder(folder.id, folderName.text);
    }
    function focusName() {
        folderName.forceActiveFocus();
        folderName.selectAll();
    }
    function containsPoint(x, y) {
        return x >= card.x && y >= card.y && x < card.x + card.width && y < card.y + card.height;
    }

    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: page.folderDragOutside ? 0 : 0.35
    }
    MouseArea {
        anchors.fill: parent
        enabled: !page.dragging
        onClicked: page.closeFolder()
    }
    Rectangle {
        id: card
        objectName: "pinFolderCard"
        anchors.centerIn: parent
        width: Math.min(parent.width - 24, Kirigami.Units.gridUnit * 24)
        height: Math.min(parent.height - 24, header.implicitHeight + 32
                         + Math.max(1, Math.ceil(folderGrid.count / 3)) * folderGrid.cellHeight)
        radius: 12
        color: Kirigami.Theme.backgroundColor
        border.width: 1
        border.color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g, Kirigami.Theme.textColor.b, 0.2)
        // Keep the dragged delegate alive and its mouse grab intact while the
        // card fades away. Removing it is deferred until after button release.
        opacity: page.folderDragOutside ? 0 : 1
        MouseArea { anchors.fill: parent }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 8
            RowLayout {
                id: header
                Layout.fillWidth: true
                PlasmaComponents3.TextField {
                    id: folderName
                    objectName: "pinFolderName"
                    Layout.fillWidth: true
                    placeholderText: qsTr("Folder")
                    maximumLength: 64
                    horizontalAlignment: Text.AlignHCenter
                    font.bold: true
                    background: Rectangle {
                        radius: 5
                        color: folderName.activeFocus ? Kirigami.Theme.alternateBackgroundColor : "transparent"
                    }
                    onEditingFinished: popup.saveName()
                    onAccepted: folderGrid.forceActiveFocus()
                    Keys.onEscapePressed: page.closeFolder()
                }
                PlasmaComponents3.ToolButton {
                    icon.name: "window-close"
                    text: qsTr("Close folder")
                    display: PlasmaComponents3.ToolButton.IconOnly
                    onClicked: page.closeFolder()
                }
            }
            GridView {
                id: folderGrid
                objectName: "pinFolderGrid"
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                cellWidth: Math.floor(width / 3)
                cellHeight: page.cellHeight
                boundsBehavior: Flickable.StopAtBounds
                model: popup.folder ? popup.folder.items : []
                currentIndex: -1
                delegate: PinnedTile {
                    required property var modelData
                    pin: modelData
                    page: popup.page
                    containerId: popup.folder ? popup.folder.id : ""
                }
                HoverHandler {
                    onPointChanged: {
                        if (!popup.page.dragging) folderGrid.currentIndex = folderGrid.indexAt(
                            point.position.x + folderGrid.contentX, point.position.y + folderGrid.contentY);
                    }
                }
                Keys.onReturnPressed: page.activateCurrent()
                Keys.onEnterPressed: page.activateCurrent()
                Keys.onSpacePressed: page.activateCurrent()
                Keys.onEscapePressed: page.closeFolder()
            }
        }
    }
}
