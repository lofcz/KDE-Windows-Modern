/* SPDX-License-Identifier: GPL-3.0-or-later */
import QtQml
import QtQml.Models
import "../code/pinlayout.js" as Layout
import "../code/tools.js" as Tools

QtObject {
    id: store
    property var favoritesModel: null
    property string serializedLayout: ""
    property var savedItems: Layout.parse(serializedLayout)
    property var items: []
    property var tiles: []
    property var apps: ({})
    signal layoutSaved(string serialized)

    onSerializedLayoutChanged: {
        savedItems = Layout.parse(serializedLayout);
        refreshTimer.restart();
    }

    // Observe actual model roles, including QIcon values and the source row.
    // Never save during model loading: an initially empty/partial favorites
    // model must not erase the persisted folder membership.
    readonly property Instantiator entries: Instantiator {
        model: store.favoritesModel
        delegate: QtObject {
            required property var model
            required property int index
            readonly property var entry: ({
                id: String(Tools.resolveFavoriteId(model.favoriteId, model.url)),
                row: index,
                name: String(model.name ?? model.display ?? ""),
                icon: model.decoration ?? "application-x-executable",
                url: model.url ?? "",
                actionList: model.actionList ?? []
            })
            onEntryChanged: store.refreshTimer.restart()
        }
        onObjectAdded: store.refreshTimer.restart()
        onObjectRemoved: store.refreshTimer.restart()
    }

    readonly property Timer refreshTimer: Timer {
        interval: 0
        onTriggered: store.refresh()
    }

    function resolve(entry) {
        if (entry.type === "app") {
            const metadata = apps[entry.id];
            return {type: "app", id: entry.id, name: metadata.name, icon: metadata.icon};
        }
        return {type: "folder", id: entry.id, name: entry.name,
                items: entry.items.map(child => resolve(child))};
    }

    function rebuild() {
        const ids = Object.keys(apps).sort((a, b) => apps[a].row - apps[b].row);
        items = Layout.reconcile(savedItems, ids);
        tiles = items.map(entry => resolve(entry));
    }

    function refresh() {
        const next = {};
        for (let index = 0; index < entries.count; ++index) {
            const object = entries.objectAt(index);
            if (object && object.entry.id) next[object.entry.id] = object.entry;
        }
        apps = next;
        rebuild();
    }

    function save(next) {
        savedItems = Layout.normalize(next);
        rebuild();
        layoutSaved(Layout.serialize(savedItems));
    }

    function move(sourceId, sourceFolder, targetId, targetFolder, mode) {
        const id = "folder:" + Date.now().toString(36) + ":" + Math.random().toString(36).slice(2);
        save(Layout.move(items, sourceId, sourceFolder, targetId, targetFolder, mode, id, ""));
    }

    function rename(folderId, name) { save(Layout.rename(items, folderId, name)); }
    function forget(appId) { save(Layout.forget(savedItems, appId)); }
    function folder(id) { return tiles.find(entry => entry.type === "folder" && entry.id === id) ?? null; }

    function launch(appId) {
        const entry = apps[appId];
        return entry && favoritesModel ? favoritesModel.trigger(entry.row, "", null) : false;
    }
}
