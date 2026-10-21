/* SPDX-License-Identifier: GPL-2.0-or-later */
import QtQml

QtObject {
    id: controller

    required property QtObject authenticator
    property bool expectingPrompt: true
    property bool showPrompt: false
    property string pendingPassword: ""
    // CachyOS exposes inPasswordDelay; other 6.8 builds use pamTimeout.
    readonly property bool passwordDelay: authenticator.inPasswordDelay ?? authenticator.pamTimeout ?? false
    readonly property bool waitingForPam: pendingPassword.length > 0 && passwordDelay
    onPasswordDelayChanged: {
        if (!passwordDelay && pendingPassword.length > 0) {
            const password = pendingPassword;
            pendingPassword = "";
            authenticator.respond(password);
        }
    }

    signal clearPassword()
    signal rejected()
    signal authenticated(bool immediate)
    signal message(string text)
    signal secretPrompted()

    function submit(password: string): void {
        if (authenticator.unlocked) {
            return;
        }
        if (passwordDelay) {
            pendingPassword = password;
        } else {
            pendingPassword = "";
            authenticator.respond(password);
        }
    }

    function reset(): void {
        pendingPassword = "";
        clearPassword();
    }

    function selectAuthenticator(type: int, expectsPrompt: bool, displaysPrompt: bool): void {
        reset();
        expectingPrompt = expectsPrompt;
        showPrompt = displaysPrompt;
        authenticator.authenticator = type;
    }

    readonly property Connections backendConnections: Connections {
        target: controller.authenticator

        function onFailed(kind): void {
            if (kind !== 0) {
                return;
            }
            controller.reset();
            controller.authenticator.startAuthenticating();
            controller.rejected();
        }

        function onSucceeded(): void {
            controller.authenticator.stopAuthenticating();
            controller.reset();
            controller.authenticated(!controller.expectingPrompt || controller.authenticator.hadPrompt);
        }

        function onInfoMessageChanged(): void { controller.message(controller.authenticator.infoMessage); }
        function onErrorMessageChanged(): void { controller.message(controller.authenticator.errorMessage); }
        function onPromptChanged(): void { controller.message(controller.authenticator.prompt); }
        function onPromptForSecretChanged(): void {
            controller.secretPrompted();
            if (controller.showPrompt) {
                controller.message(controller.authenticator.promptForSecret);
            }
        }
    }
}
