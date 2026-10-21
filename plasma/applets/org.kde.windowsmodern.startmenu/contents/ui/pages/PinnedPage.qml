/* SPDX-License-Identifier: GPL-3.0-or-later */
import QtQuick
import QtQuick.Layouts
import org.kde.plasma.components as PlasmaComponents3
import org.kde.kirigami as Kirigami
import "../components"
import "../code/tools.js" as Tools

Item {
    id: pinnedPage
    property alias favoritesModel: store.favoritesModel
    property alias favoritesList: favoritesGrid
    readonly property alias pinStore: store
    property int columns: 6
    property string serializedLayout: ""
    property string openFolderId: ""
    readonly property var openFolder: store.folder(openFolderId)
    readonly property bool folderOpen: openFolder !== null
    readonly property int cellHeight: Math.round(Kirigami.Units.iconSizes.large * 0.9
        + Kirigami.Theme.defaultFont.pixelSize * 2.4 + Kirigami.Units.largeSpacing)

    property bool dragging: false
    property string dragId: ""
    property string dragSourceFolder: ""
    property var dragPin: null
    property real dragX: 0
    property real dragY: 0
    property bool folderDragOutside: false
    property string targetId: ""
    property string targetFolder: ""
    property string reorderMode: "end"
    property bool groupCandidate: false
    property bool groupReady: false
    property bool validDrop: false
    readonly property string dropMode: groupCandidate && groupReady ? "inside" : reorderMode

    signal showAllAppsRequested
    signal keyNavUpFromList
    signal launched
    signal layoutSaved(string serialized)
    signal contextMenuRequested(var actions, real x, real y, var context)
    onVisibleChanged: if (!visible) dismiss()

    PinStore {
        id: store
        serializedLayout: pinnedPage.serializedLayout
        onLayoutSaved: serialized => pinnedPage.layoutSaved(serialized)
        onTilesChanged: {
            if (pinnedPage.openFolderId && !store.folder(pinnedPage.openFolderId))
                pinnedPage.openFolderId = "";
        }
    }

    function activeGrid() { return folderOpen ? folderPopup.grid : favoritesGrid; }
    function tryActivate(row) {
        const grid = activeGrid();
        if (grid.count > 0) {
            grid.currentIndex = Math.max(0, Math.min(row, grid.count - 1));
            grid.forceActiveFocus();
        }
    }
    function navigateUp() {
        const grid = activeGrid();
        if (grid.count) grid.currentIndex = Math.max(0, grid.currentIndex - (folderOpen ? 3 : columns));
    }
    function navigateDown() {
        const grid = activeGrid();
        if (grid.count) grid.currentIndex = grid.currentIndex < 0 ? 0
            : Math.min(grid.count - 1, grid.currentIndex + (folderOpen ? 3 : columns));
    }
    function activateAt(index) {
        const pins = folderOpen ? openFolder.items : store.tiles;
        if (index >= 0 && index < pins.length) activate(pins[index]);
    }
    function activateCurrent() { activateAt(activeGrid().currentIndex); }
    function activate(pin) {
        if (pin.type === "folder") {
            openFolderId = pin.id;
            Qt.callLater(function() {
                folderPopup.grid.currentIndex = 0;
                folderPopup.grid.forceActiveFocus();
            });
        } else if (store.launch(pin.id)) launched();
    }
    function closeFolder() {
        folderPopup.saveName();
        openFolderId = "";
        favoritesGrid.forceActiveFocus();
    }
    function renameFolder(id, name) { store.rename(id, name); }
    function forgetPin(id) { store.forget(id); }
    function dismiss() {
        cancelDrag();
        if (folderOpen) closeFolder();
    }

    function openPinContext(pin, folderId, x, y) {
        let actions;
        let context = {pinId: pin.id, folderId: folderId};
        if (pin.type === "folder") {
            actions = [{text: qsTr("Rename folder"), icon: "edit-rename", actionId: "_pin_rename_folder"}];
        } else {
            const entry = store.apps[pin.id];
            if (!entry) return;
            actions = Tools.buildAppActions(qsTr, favoritesModel, pin.id, entry.url, entry.actionList);
            context.model = favoritesModel;
            context.index = entry.row;
            if (folderId) actions.unshift({text: qsTr("Move out of folder"), icon: "go-up", actionId: "_pin_move_out"});
        }
        contextMenuRequested(actions, x, y, context);
    }
    function handleContextAction(actionId, context) {
        if (actionId === "_pin_rename_folder" && context) {
            openFolderId = context.pinId;
            Qt.callLater(folderPopup.focusName);
            return true;
        }
        if (actionId === "_pin_move_out" && context) {
            store.move(context.pinId, context.folderId, "", "", "end");
            closeFolder();
            return true;
        }
        return false;
    }

    function beginDrag(pin, folderId) {
        dragPin = pin;
        dragId = pin.id;
        dragSourceFolder = folderId;
        folderDragOutside = false;
        dragging = true;
        validDrop = false;
    }
    function dropGrid() { return folderOpen && !folderDragOutside ? folderPopup.grid : favoritesGrid; }
    function updateDrag(x, y) {
        if (!dragging) return;
        dragX = x; dragY = y;
        validDrop = x >= 0 && y >= 0 && x < width && y < height;
        if (dragSourceFolder && folderOpen && !folderPopup.containsPoint(x, y)) folderDragOutside = true;
        const grid = dropGrid();
        const point = grid.mapFromItem(pinnedPage, x, y);
        const cx = point.x + grid.contentX, cy = point.y + grid.contentY;
        const index = point.x >= 0 && point.y >= 0 && point.x < grid.width && point.y < grid.height
            ? grid.indexAt(cx, cy) : -1;
        const pins = grid === favoritesGrid ? store.tiles : openFolder.items;
        const nextFolder = grid === favoritesGrid ? "" : openFolderId;
        let nextId = "", nextMode = "end", candidate = false;
        if (index >= 0 && index < pins.length) {
            const pin = pins[index];
            nextId = pin.id;
            const cellX = cx % grid.cellWidth, cellY = cy % grid.cellHeight;
            nextMode = cellX < grid.cellWidth / 2 ? "before" : "after";
            candidate = grid === favoritesGrid && dragPin.type === "app" && pin.id !== dragId
                && cellX > grid.cellWidth * 0.25 && cellX < grid.cellWidth * 0.75
                && cellY > grid.cellHeight * 0.1 && cellY < grid.cellHeight * 0.85;
        }
        if (nextId !== targetId || nextFolder !== targetFolder || candidate !== groupCandidate) {
            groupTimer.stop();
            groupReady = false;
            if (candidate) groupTimer.start();
        }
        targetId = nextId;
        targetFolder = nextFolder;
        reorderMode = nextMode;
        groupCandidate = candidate;
    }
    function cancelDrag() {
        groupTimer.stop();
        dragging = false;
        dragId = "";
        dragPin = null;
        targetId = "";
        groupCandidate = false;
        groupReady = false;
        validDrop = false;
        folderDragOutside = false;
    }
    function finishDrag() {
        if (!dragging) return;
        const source = dragId, from = dragSourceFolder, target = targetId, into = targetFolder;
        const mode = dropMode, accepted = validDrop;
        cancelDrag();
        // Updating a JS-array model recreates delegates. Wait until MouseArea
        // has released its grab before removing the source tile or folder.
        Qt.callLater(function() {
            if (accepted) store.move(source, from, target, into, mode);
            if (from && folderOpen) closeFolder();
        });
    }

    Timer { id: groupTimer; interval: 380; onTriggered: pinnedPage.groupReady = pinnedPage.groupCandidate }
    Timer {
        interval: 60
        repeat: true
        running: pinnedPage.dragging
        onTriggered: {
            const grid = pinnedPage.dropGrid();
            const point = grid.mapFromItem(pinnedPage, pinnedPage.dragX, pinnedPage.dragY);
            if (point.x < 0 || point.x > grid.width) return;
            const dy = point.y < 28 ? -12 : (point.y > grid.height - 28 ? 12 : 0);
            const next = Math.max(0, Math.min(grid.contentHeight - grid.height, grid.contentY + dy));
            if (dy && next !== grid.contentY) {
                grid.contentY = next;
                pinnedPage.updateDrag(pinnedPage.dragX, pinnedPage.dragY);
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: Kirigami.Units.largeSpacing
        RowLayout {
            Layout.fillWidth: true
            PlasmaComponents3.Label {
                text: qsTr("Pinned")
                font.pixelSize: Math.round(Kirigami.Theme.defaultFont.pixelSize * 1.15)
                font.weight: Font.DemiBold
            }
            Item { Layout.fillWidth: true }
            AToolButton {
                buttonHeight: 24
                iconName: "go-next"
                text: qsTr("All apps")
                onClicked: pinnedPage.showAllAppsRequested()
            }
        }
        GridView {
            id: favoritesGrid
            objectName: "pinnedGrid"
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            interactive: contentHeight > height
            boundsBehavior: Flickable.StopAtBounds
            currentIndex: -1
            cellWidth: Math.floor(width / pinnedPage.columns)
            cellHeight: pinnedPage.cellHeight
            model: store.tiles
            delegate: PinnedTile {
                required property var modelData
                pin: modelData
                page: pinnedPage
            }
            highlightMoveDuration: 0
            HoverHandler {
                onPointChanged: {
                    if (!pinnedPage.dragging) favoritesGrid.currentIndex = favoritesGrid.indexAt(
                        point.position.x + favoritesGrid.contentX, point.position.y + favoritesGrid.contentY);
                }
                onHoveredChanged: if (!hovered && !pinnedPage.dragging) favoritesGrid.currentIndex = -1
            }
            Keys.onLeftPressed: event => { currentIndex = Math.max(0, currentIndex - 1); event.accepted = true; }
            Keys.onRightPressed: event => { currentIndex = Math.min(count - 1, currentIndex + 1); event.accepted = true; }
            Keys.onUpPressed: event => {
                event.accepted = true;
                if (currentIndex < pinnedPage.columns) pinnedPage.keyNavUpFromList();
                else currentIndex -= pinnedPage.columns;
            }
            Keys.onDownPressed: event => { pinnedPage.navigateDown(); event.accepted = true; }
            Keys.onReturnPressed: pinnedPage.activateCurrent()
            Keys.onEnterPressed: pinnedPage.activateCurrent()
            Keys.onSpacePressed: pinnedPage.activateCurrent()
        }
    }
    PinFolderPopup {
        id: folderPopup
        page: pinnedPage
        folder: pinnedPage.openFolder
    }
    Item {
        visible: pinnedPage.dragging
        x: pinnedPage.dragX - width / 2
        y: pinnedPage.dragY - 22
        width: 84
        height: 90
        z: 200
        opacity: 0.95
        Column {
            anchors.fill: parent
            spacing: 4
            Kirigami.Icon {
                anchors.horizontalCenter: parent.horizontalCenter
                width: 44; height: 44
                source: pinnedPage.dragPin ? (pinnedPage.dragPin.type === "folder" ? "folder" : pinnedPage.dragPin.icon) : ""
            }
            PlasmaComponents3.Label {
                width: parent.width
                text: pinnedPage.dragPin ? pinnedPage.dragPin.name || qsTr("Folder") : ""
                wrapMode: Text.WordWrap
                maximumLineCount: 2
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignHCenter
                textFormat: Text.PlainText
            }
        }
    }
    Keys.onEscapePressed: event => {
        if (dragging) { cancelDrag(); event.accepted = true; }
        else if (folderOpen) { closeFolder(); event.accepted = true; }
        else event.accepted = false;
    }
}
