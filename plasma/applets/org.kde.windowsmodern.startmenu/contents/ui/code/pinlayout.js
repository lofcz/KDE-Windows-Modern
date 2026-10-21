/* SPDX-License-Identifier: GPL-3.0-or-later */
.pragma library

function app(id) { return {type: "app", id: id}; }

// Only one folder level is allowed. Every app appears once, and folders with
// fewer than two children are replaced by their remaining app (or removed).
function normalize(items, available) {
    const seen = new Set();
    const folders = new Set();
    const allowed = available === undefined ? null : new Set(available);
    function take(entry) {
        if (!entry || entry.type !== "app" || typeof entry.id !== "string"
                || !entry.id || seen.has(entry.id) || (allowed && !allowed.has(entry.id)))
            return null;
        seen.add(entry.id);
        return app(entry.id);
    }
    const result = [];
    for (const entry of Array.isArray(items) ? items : []) {
        if (entry && entry.type === "folder" && typeof entry.id === "string"
                && entry.id && !folders.has(entry.id)) {
            folders.add(entry.id);
            const children = [];
            for (const child of Array.isArray(entry.items) ? entry.items : []) {
                const accepted = take(child);
                if (accepted) children.push(accepted);
            }
            if (children.length === 1) result.push(children[0]);
            else if (children.length > 1) result.push({
                type: "folder", id: entry.id,
                name: typeof entry.name === "string" ? entry.name.slice(0, 64) : "",
                items: children
            });
        } else {
            const accepted = take(entry);
            if (accepted) result.push(accepted);
        }
    }
    return result;
}

function parse(serialized) {
    try {
        const value = JSON.parse(serialized);
        return value.version === 1 ? normalize(value.items) : [];
    } catch (_) { return []; }
}

function serialize(items) { return JSON.stringify({version: 1, items: normalize(items)}); }

function reconcile(items, favoriteIds) {
    const result = normalize(items, favoriteIds);
    const used = new Set();
    for (const entry of result) {
        for (const child of entry.type === "folder" ? entry.items : [entry]) used.add(child.id);
    }
    for (const id of favoriteIds) {
        if (id && !used.has(id)) { result.push(app(id)); used.add(id); }
    }
    return result;
}

function container(items, folderId) {
    if (!folderId) return items;
    const folder = items.find(entry => entry.type === "folder" && entry.id === folderId);
    return folder ? folder.items : null;
}

function move(items, sourceId, sourceFolder, targetId, targetFolder, mode, folderId, folderName) {
    const original = normalize(items);
    const result = JSON.parse(JSON.stringify(original));
    const from = container(result, sourceFolder);
    const to = container(result, targetFolder);
    if (!from || !to || (sourceId === targetId && sourceFolder === targetFolder)) return original;
    const sourceIndex = from.findIndex(entry => entry.id === sourceId);
    if (sourceIndex < 0) return original;
    const source = from[sourceIndex];
    if (source.type === "folder" && (targetFolder || mode === "inside")) return original;
    if (mode === "inside" && (targetFolder || sourceFolder === targetId)) return original;
    if (!["before", "after", "inside", "end"].includes(mode)) return original;
    from.splice(sourceIndex, 1);

    if (mode === "inside") {
        const index = to.findIndex(entry => entry.id === targetId);
        if (index < 0 || source.type !== "app") return original;
        if (to[index].type === "folder") to[index].items.push(source);
        else {
            if (!folderId) return original;
            to[index] = {type: "folder", id: folderId, name: folderName || "", items: [to[index], source]};
        }
    } else {
        const index = mode === "end" ? to.length : to.findIndex(entry => entry.id === targetId);
        if (index < 0) return original;
        to.splice(index + (mode === "after" ? 1 : 0), 0, source);
    }
    return normalize(result);
}

function rename(items, folderId, name) {
    const result = normalize(items);
    const folder = result.find(entry => entry.type === "folder" && entry.id === folderId);
    if (folder) folder.name = String(name).trim().slice(0, 64);
    return result;
}

function forget(items, appId) {
    return normalize(normalize(items).map(entry => entry.type === "folder"
        ? {type: "folder", id: entry.id, name: entry.name, items: entry.items.filter(child => child.id !== appId)}
        : entry).filter(entry => entry.type === "folder" || entry.id !== appId));
}
