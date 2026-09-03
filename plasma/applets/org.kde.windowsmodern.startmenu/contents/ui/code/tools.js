/*
    SPDX-FileCopyrightText: 2013 Aurélien Gâteau <agateau@kde.org>
    SPDX-FileCopyrightText: 2013-2015 Eike Hein <hein@kde.org>
    SPDX-FileCopyrightText: 2017 Ivan Cukic <ivan.cukic@kde.org>

    SPDX-License-Identifier: GPL-2.0-or-later
*/

.pragma library

// Resolve a stable favorite id for a model entry. Some entries leave
// favoriteId empty (e.g. transient runner results), so fall back to the
// url — both are accepted by the favorites model.
function resolveFavoriteId(favoriteId, url) {
    if (favoriteId !== undefined && favoriteId !== null && favoriteId !== "") {
        return favoriteId;
    }
    if (url !== undefined && url !== null && url !== "") {
        return url.toString();
    }
    return "";
}

function isUninstallAction(action) {
    if (!action) {
        return false;
    }
    var id = action.actionId || "";
    var text = action.text || "";
    if (id === "manageApplication") {
        return true;
    }
    if (text.indexOf("Uninstall") !== -1 || text.indexOf("Manage Add-On") !== -1
            || text.indexOf("Manage Add-on") !== -1) {
        return true;
    }
    return false;
}

function compactSeparators(acts) {
    var out = [];
    for (var i = 0; i < acts.length; i++) {
        var a = acts[i];
        if (a && a.type === "separator") {
            if (out.length === 0 || out[out.length - 1].type === "separator") {
                continue;
            }
            out.push(a);
            continue;
        }
        out.push(a);
    }
    if (out.length > 0 && out[out.length - 1].type === "separator") {
        out.pop();
    }
    return out;
}

// Build the full context-menu action list for an app: the app's own
// actions followed by a pin/unpin favorite action.  Used by both the
// All Apps list and search results so the right-click menu is identical
// for the same app in either place.
function buildAppActions(i18n, favoriteModel, favoriteId, url, actionList) {
    var acts = [];
    var hasEditPin = false;

    if (actionList && actionList.length > 0) {
        for (var i = 0; i < actionList.length; i++) {
            var action = actionList[i];
            if (isUninstallAction(action)) {
                continue;
            }
            if (action && action.actionId === "editApplication") {
                acts.push({
                    text: i18n("Edit Pin"),
                    icon: action.icon || "document-edit",
                    actionId: action.actionId,
                    actionArgument: action.actionArgument
                });
                hasEditPin = true;
                continue;
            }
            acts.push(action);
        }
    }

    if (!hasEditPin) {
        acts.push({
            text: i18n("Edit Pin"),
            icon: "document-edit",
            actionId: "editApplication"
        });
    }

    var favId = resolveFavoriteId(favoriteId, url);
    var favActions = createFavoriteActions(i18n, favoriteModel, favId);
    if (favActions) {
        if (acts.length > 0) {
            acts.push({ "type": "separator" });
        }
        acts = acts.concat(favActions);
    }

    return compactSeparators(acts);
}

function createFavoriteActions(i18n, favoriteModel, favoriteId) {
    if (!favoriteModel || !favoriteModel.enabled || !favoriteId) {
        return null;
    }

    if (favoriteModel.activities === undefined
        || !favoriteModel.activities.hasOwnProperty("runningActivities")
        || favoriteModel.activities.runningActivities.length <= 1) {

        var action = {};

        if (favoriteModel.isFavorite(favoriteId)) {
            action.text = i18n("Unpin from Start");
            action.icon = "window-unpin";
            action.actionId = "_kicker_favorite_remove";
        } else if (favoriteModel.maxFavorites === -1
                   || favoriteModel.count < favoriteModel.maxFavorites) {
            action.text = i18n("Pin to Start");
            action.icon = "window-pin";
            action.actionId = "_kicker_favorite_add";
        } else {
            return null;
        }

        action.actionArgument = { favoriteModel: favoriteModel, favoriteId: favoriteId };

        return [action];
    }

    var actions = [];
    var linkedActivities = favoriteModel.linkedActivitiesFor(favoriteId);
    var activities = favoriteModel.activities.runningActivities;

    var linkedToAllActivities = linkedActivities.indexOf(":global") !== -1;

    actions.push({
        text: i18n("On All Activities"),
        checkable: true,
        actionId: linkedToAllActivities
            ? "_kicker_favorite_remove_from_activity"
            : "_kicker_favorite_set_to_activity",
        checked: linkedToAllActivities,
        actionArgument: {
            favoriteModel: favoriteModel,
            favoriteId: favoriteId,
            favoriteActivity: ""
        }
    });

    var addActivityItem = function (activityId, activityName) {
        var linkedToThisActivity = linkedActivities.indexOf(activityId) !== -1;

        actions.push({
            text: activityName,
            checkable: true,
            checked: linkedToThisActivity && !linkedToAllActivities,
            actionId: linkedToAllActivities
                ? "_kicker_favorite_set_to_activity"
                : linkedToThisActivity
                    ? "_kicker_favorite_remove_from_activity"
                    : "_kicker_favorite_add_to_activity",
            actionArgument: {
                favoriteModel: favoriteModel,
                favoriteId: favoriteId,
                favoriteActivity: activityId
            }
        });
    };

    addActivityItem(favoriteModel.activities.currentActivity,
                    i18n("On the Current Activity"));

    actions.push({ "type": "separator", "actionId": "_kicker_favorite_separator" });

    activities.forEach(function (activityId) {
        addActivityItem(activityId, favoriteModel.activityNameForId(activityId));
    });

    return [{
        text: i18n("Pin to Start"),
        icon: "window-pin",
        subActions: actions
    }];
}

function triggerAction(model, index, actionId, actionArgument) {
    if (actionId.indexOf("_kicker_favorite_") === 0) {
        handleFavoriteAction(actionId, actionArgument);
        return;
    }

    if (model && typeof model.trigger === "function") {
        return model.trigger(index, actionId, actionArgument) === true;
    }

    return false;
}

function handleFavoriteAction(actionId, actionArgument) {
    if (!actionArgument) return;

    var favoriteId = actionArgument.favoriteId;
    var favoriteModel = actionArgument.favoriteModel;

    if (favoriteModel === null || favoriteId === null) {
        return;
    }

    if (actionId === "_kicker_favorite_remove") {
        favoriteModel.removeFavorite(favoriteId);
    } else if (actionId === "_kicker_favorite_add") {
        favoriteModel.addFavorite(favoriteId);
    } else if (actionId === "_kicker_favorite_remove_from_activity") {
        favoriteModel.removeFavoriteFrom(favoriteId, actionArgument.favoriteActivity);
    } else if (actionId === "_kicker_favorite_add_to_activity") {
        favoriteModel.addFavoriteTo(favoriteId, actionArgument.favoriteActivity);
    } else if (actionId === "_kicker_favorite_set_to_activity") {
        favoriteModel.setFavoriteOn(favoriteId, actionArgument.favoriteActivity);
    }
}
