import QtQml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

import org.kde.plasma.components as PlasmaComponents3
import org.kde.plasma.workspace.components as PW
import org.kde.kirigami as Kirigami
import org.kde.plasma.private.sessions
import org.kde.plasma.private.keyboardindicator as KeyboardIndicator
import org.kde.plasma.workspace.keyboardlayout as Keyboards
import org.kde.plasma.private.accessibility
import org.kde.kscreenlocker as ScreenLocker
import org.kde.breeze.components

Item {
    id: lockScreenUi

    readonly property bool softwareRendering: GraphicsInfo.api === GraphicsInfo.Software
    readonly property QtObject authenticationBackend: authenticator

    function handleMessage(msg) {
        if (!root.notification) {
            root.notification += msg;
        } else if (root.notification.includes(msg)) {
            root.notificationRepeated();
        } else {
            root.notification += "\n" + msg
        }
        lockScreenRoot.uiVisible = true;
    }

    Kirigami.Theme.inherit: false
    Kirigami.Theme.colorSet: Kirigami.Theme.Complementary

    // ── Authenticator connections ──
    LockScreenAuth {
        id: authentication
        authenticator: lockScreenUi.authenticationBackend
        onClearPassword: root.clearPassword()
        onRejected: {
            const msg = i18ndc("plasma_shell_org.kde.plasma.desktop", "@info:status", "Unlocking failed");
            lockScreenUi.handleMessage(msg);
            notificationRemoveTimer.restart();
            rejectPasswordAnimation.start();
        }
        onAuthenticated: immediate => {
            if (immediate) {
                Qt.quit();
            } else {
                mainStack.replace(null, Qt.resolvedUrl("NoPasswordUnlock.qml"),
                    { userListModel: users }, StackView.Immediate);
                mainStack.forceActiveFocus();
            }
        }
        onMessage: text => lockScreenUi.handleMessage(text)
        onSecretPrompted: {
            mainBlock.showPassword = false;
            mainBlock.mainPasswordBox.forceActiveFocus();
        }
    }

    SessionManagement {
        id: sessionManagement
    }

    AccessibilityStatus { id: accessibilityStatus }

    Connections {
        target: sessionManagement
        function onAboutToSuspend() { authentication.reset(); }
    }

    RejectPasswordAnimation {
        id: rejectPasswordAnimation
        target: mainBlock
    }

    KeyboardIndicator.KeyState {
        id: capsLockState
        key: Qt.Key_CapsLock
    }

    // ── Launch animation ──
    PropertyAnimation {
        id: launchAnimation
        target: lockScreenRoot
        property: "opacity"
        from: 0
        to: 1
        duration: Kirigami.Units.veryLongDuration * 2
    }

    Component.onCompleted: launchAnimation.start();

    // ── Interaction layer ──
    MouseArea {
        id: lockScreenRoot
        anchors.fill: parent
        hoverEnabled: true

        property bool uiVisible: false
        property bool blockUI: containsMouse && (mainStack.depth > 1 || mainBlock.mainPasswordBox.text.length > 0 || Keyboards.KWinVirtualKeyboard.visible)
        property bool loginUiActive: uiVisible || mainBlock.mainPasswordBox.text.length > 0 || authentication.waitingForPam
        cursorShape: Qt.ArrowCursor
        drag.filterChildren: true

        onEntered: {
            uiVisible = true;
            fadeoutTimer.restart();
        }
        onPressed: (mouse) => {
            var item = lockScreenRoot.childAt(mouse.x, mouse.y);
            while (item && item !== lockScreenRoot) {
                if (item === statusIcons || item === mediaControlsLoader) {
                    return;
                }
                item = item.parent;
            }
            uiVisible = true;
        }
        onUiVisibleChanged: {
            if (uiVisible) { Window.window.requestActivate() }
            if (blockUI) { fadeoutTimer.running = false }
            else if (uiVisible) { fadeoutTimer.restart() }
            authenticator.startAuthenticating();
        }
        onBlockUIChanged: {
            if (blockUI) { fadeoutTimer.running = false; uiVisible = true }
            else { fadeoutTimer.restart() }
        }
        ScreenLocker.ActiveScreenMonitor {
            lockscreenState: ScreenLocker.LockscreenState
            window: lockScreenRoot.Window.window
            onActiveChanged: {
                if (!active && !powerMenu.opened) lockScreenRoot.uiVisible = false;
            }
        }
        Keys.onEscapePressed: {
            if (uiVisible) {
                uiVisible = false;
                Keyboards.KWinVirtualKeyboard.active = false;
                authentication.reset();
            }
        }
        Keys.onPressed: event => { uiVisible = true; event.accepted = false }

        Timer {
            id: fadeoutTimer
            interval: 60000
            onTriggered: {
                if (!lockScreenRoot.blockUI) {
                    mainBlock.mainPasswordBox.showPassword = false;
                    lockScreenRoot.uiVisible = false;
                }
            }
        }
        Timer { id: notificationRemoveTimer; interval: 3000; onTriggered: root.notification = "" }
        Timer {
            interval: 1000
            repeat: true
            running: !authenticator.unlocked && lockScreenRoot.uiVisible
            onTriggered: authenticator.startAuthenticating()
        }

        // ── Wallpaper layer ──
        FastBlur {
            id: wallpaperFader
            anchors.fill: parent
            source: wallpaper
            radius: lockScreenRoot.loginUiActive ? 50 : 0
            visible: radius > 0
            Behavior on radius {
                NumberAnimation {
                    duration: Kirigami.Units.veryLongDuration * 2
                    easing.type: Easing.InOutQuad
                }
            }
        }

        // ── Dark overlay (Win11 lock dimming) ──
        Rectangle {
            anchors.fill: parent
            color: "#000000"
            opacity: lockScreenRoot.loginUiActive ? 0.45 : 0.0

            Behavior on opacity {
                NumberAnimation {
                    duration: Kirigami.Units.veryLongDuration * 2
                    easing.type: Easing.InOutQuad
                }
            }
        }

        // ── Center clock (Windows 11 style) ──
        Item {
            id: clockContainer
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: parent.height * 0.15
            width: childrenRect.width
            height: childrenRect.height

            opacity: lockScreenRoot.loginUiActive ? 0.0 : 1.0
            visible: opacity > 0

            Behavior on opacity {
                OpacityAnimator {
                    duration: Kirigami.Units.veryLongDuration * 2
                    easing.type: Easing.InOutQuad
                }
            }

            DropShadow {
                id: clockShadow
                anchors.fill: windowsClock
                source: windowsClock
                visible: !lockScreenUi.softwareRendering
                radius: 7
                verticalOffset: 0.8
                samples: 15
                spread: 0.2
                color: Qt.rgba(0, 0, 0, 0.7)
            }

            Column {
                id: windowsClock
                property Item shadow: clockShadow
                spacing: Kirigami.Units.smallSpacing / 2

                Text {
                    id: timeText
                    text: Qt.formatTime(new Date(), "HH:mm")
                    font.family: "Segoe UI"
                    font.weight: Font.DemiBold
                    font.pixelSize: 96
                    color: "#FFFFFF"
                    horizontalAlignment: Text.AlignHCenter
                    antialiasing: true
                }
                Text {
                    id: dateText
                    text: Qt.formatDate(new Date(), "dddd, MMMM d")
                    font.family: "Segoe UI"
                    font.weight: Font.Normal
                    font.pixelSize: 24
                    color: "#E0E0E0"
                    horizontalAlignment: Text.AlignHCenter
                    antialiasing: true
                }
            }
        }

        // ── Optional Media Controls (Idle only, below clock) ──
        Loader {
            id: mediaControlsLoader
            anchors.top: clockContainer.bottom
            anchors.topMargin: Kirigami.Units.largeSpacing * 2
            anchors.horizontalCenter: parent.horizontalCenter
            source: "MediaControls.qml"
            active: config.showMediaControls ?? true
            visible: !lockScreenRoot.loginUiActive
        }

        // ── Status icons (bottom-right, icon-only, idle only) ──
        Row {
            id: statusIcons
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: Kirigami.Units.largeSpacing
            spacing: Kirigami.Units.mediumSpacing
            visible: !lockScreenRoot.loginUiActive

            PlasmaComponents3.ToolButton {
                width: 32
                height: 32
                icon.name: "network-wireless"
                icon.color: "#FFFFFF"
                display: AbstractButton.IconOnly
                flat: true
                Kirigami.Theme.inherit: false
                Kirigami.Theme.colorSet: Kirigami.Theme.Complementary
            }

            // Volume Icon
            PlasmaComponents3.ToolButton {
                width: 32
                height: 32
                icon.name: "audio-volume-high"
                icon.color: "#FFFFFF"
                display: AbstractButton.IconOnly
                flat: true
                Kirigami.Theme.inherit: false
                Kirigami.Theme.colorSet: Kirigami.Theme.Complementary
            }

            PlasmaComponents3.ToolButton {
                width: 32
                height: 32
                icon.name: "battery-full"
                icon.color: "#FFFFFF"
                display: AbstractButton.IconOnly
                flat: true
                Kirigami.Theme.inherit: false
                Kirigami.Theme.colorSet: Kirigami.Theme.Complementary
            }
        }

        // ── Main unlock UI ──
        StackView {
            id: mainStack
            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
                verticalCenterOffset: -parent.height * 0.15
            }
            width: Math.min(parent.width * 0.9, 480)
            height: Math.min(parent.height * 0.8, 600)
            focus: true
            visible: opacity > 0
            opacity: lockScreenRoot.loginUiActive ? 1.0 : 0.0

            Behavior on opacity {
                NumberAnimation {
                    duration: Kirigami.Units.veryLongDuration * 2
                    easing.type: Easing.InOutQuad
                }
            }

            initialItem: MainBlock {
                id: mainBlock
                lockScreenUiVisible: lockScreenRoot.uiVisible
                showUserList: true
                enabled: !authentication.waitingForPam
                lockedOut: authentication.waitingForPam
                StackView.onStatusChanged: {
                    if (StackView.status === StackView.Activating) {
                        mainPasswordBox.clear(); mainPasswordBox.focus = true; root.notification = "";
                    }
                }
                userListModel: users
                authenticationTypeItem: RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    visible: authenticationMethods.count > 1
                    Repeater {
                        id: authenticationMethods
                        model: ScreenLocker.AuthenticatorModel
                        delegate: PlasmaComponents3.Button {
                            required property int type
                            required property string iconName
                            required property bool passwordField
                            required property bool expectingPrompt
                            required property string tooltip
                            required property bool showPrompt
                            required property bool functional
                            enabled: functional
                            icon.name: iconName
                            checked: authenticator.authenticator === type
                            onClicked: {
                                authentication.selectAuthenticator(type, expectingPrompt, showPrompt);
                                root.notification = "";
                                mainBlock.passwordInputVisible = passwordField;
                            }
                            onFunctionalChanged: {
                                if (!functional && checked) {
                                    authentication.reset();
                                    mainBlock.passwordInputVisible = false;
                                    lockScreenUi.handleMessage(i18ndc("plasma_shell_org.kde.plasma.desktop", "@info:status", "This authentication method is unavailable. Please try another method."));
                                }
                            }
                            PlasmaComponents3.ToolTip.text: tooltip
                            PlasmaComponents3.ToolTip.visible: hovered
                            PlasmaComponents3.ToolTip.delay: Kirigami.Units.toolTipDelay
                            Component.onCompleted: if (checked) clicked()
                        }
                    }
                }
                customErrorMessage: {
                    const parts = [];
                    if (capsLockState.locked) parts.push(i18ndc("plasma_shell_org.kde.plasma.desktop", "@info:status", "Caps Lock is on"));
                    if (accessibilityStatus.slowKeysEnabled) parts.push(i18ndc("plasma_shell_org.kde.plasma.desktop", "@info:status", "Slow Keys are enabled"));
                    if (root.notification) parts.push(root.notification);
                    return parts.join(" \u2022 ");
                }
                onPasswordResult: password => authentication.submit(password)
            }
        }

        // ── User list model ──
        ListModel {
            id: users
            Component.onCompleted: {
                users.append({
                    name: kscreenlocker_userName,
                    realName: kscreenlocker_userName,
                    icon: kscreenlocker_userImage !== ""
                        ? "file://" + kscreenlocker_userImage.split("/").map(encodeURIComponent).join("/")
                        : "",
                })
            }
        }

        // ── Bottom-left user switcher (Windows 10 style) ──
        ListView {
            id: userListSwitcher
            anchors {
                left: parent.left
                bottom: footer.top
                leftMargin: Kirigami.Units.largeSpacing
                bottomMargin: Kirigami.Units.smallSpacing
            }
            width: 200
            height: contentHeight
            model: users
            clip: true
            visible: count > 1 && lockScreenRoot.uiVisible

            delegate: Item {
                width: userListSwitcher.width
                height: 32 // Match the height of your avatar/text
                opacity: ListView.isCurrentItem ? 1.0 : 0.7

                Row {
                    anchors.fill: parent
                    spacing: Kirigami.Units.smallSpacing

                    Rectangle {
                        width: 32; height: 32
                        radius: 16
                        color: "#33FFFFFF"
                        visible: model.icon !== ""

                        Image {
                            anchors.fill: parent
                            source: model.icon
                            fillMode: Image.PreserveAspectCrop
                            clip: true
                        }
                    }

                    Text {
                        text: model.realName || model.name
                        font.family: "Segoe UI"
                        font.pixelSize: 14
                        color: "#FFFFFF"
                        verticalAlignment: Text.AlignVCenter
                        height: 32
                    }
                }

                // MouseArea sits on top of the Row to catch clicks
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        userListSwitcher.currentIndex = index
                        sessionManagement.switchUser()
                    }
                }
            }
        }

        // ── Footer (keyboard, network, audio, battery, power) - shown when unlocking ──
        RowLayout {
            id: footer
            anchors { bottom: parent.bottom; left: parent.left; right: parent.right; margins: Kirigami.Units.smallSpacing }
            spacing: Kirigami.Units.smallSpacing
            PlasmaComponents3.ToolButton {
                icon.name: Keyboards.KWinVirtualKeyboard.visible ? "input-keyboard-virtual-on" : "input-keyboard-virtual-off"
                text: i18ndc("plasma_shell_org.kde.plasma.desktop", "@action:button", "Virtual Keyboard")
                display: AbstractButton.IconOnly
                onClicked: {
                    if (Keyboards.KWinVirtualKeyboard.visible) {
                        Keyboards.KWinVirtualKeyboard.active = false;
                    } else {
                        mainBlock.mainPasswordBox.forceActiveFocus();
                        Keyboards.KWinVirtualKeyboard.forceActivate();
                    }
                }
            }
            visible: lockScreenRoot.uiVisible

            PlasmaComponents3.ToolButton {
                id: keyboardButton
                focusPolicy: Qt.TabFocus
                Accessible.description: i18ndc("plasma_shell_org.kde.plasma.desktop", "Button to change keyboard layout", "Switch layout")
                icon.name: "input-keyboard"
                PW.KeyboardLayoutSwitcher { id: keyboardLayoutSwitcher; anchors.fill: parent; acceptedButtons: Qt.NoButton }
                text: keyboardLayoutSwitcher.layoutNames.longName
                onClicked: keyboardLayoutSwitcher.keyboardLayout.switchToNextLayout()
                visible: keyboardLayoutSwitcher.hasMultipleKeyboardLayouts
                Layout.fillHeight: true
            }
            Item { Layout.fillWidth: true }
            PlasmaComponents3.ToolButton {
                width: 32
                height: 32
                icon.name: "network-wireless"
                icon.color: "#FFFFFF"
                display: AbstractButton.IconOnly
                flat: true
                Kirigami.Theme.inherit: false
                Kirigami.Theme.colorSet: Kirigami.Theme.Complementary
            }
            PlasmaComponents3.ToolButton {
                width: 32
                height: 32
                icon.name: "audio-volume-high"
                icon.color: "#FFFFFF"
                display: AbstractButton.IconOnly
                flat: true
                Kirigami.Theme.inherit: false
                Kirigami.Theme.colorSet: Kirigami.Theme.Complementary
            }
            PlasmaComponents3.ToolButton {
                width: 32
                height: 32
                icon.name: "battery-full"
                icon.color: "#FFFFFF"
                display: AbstractButton.IconOnly
                flat: true
                Kirigami.Theme.inherit: false
                Kirigami.Theme.colorSet: Kirigami.Theme.Complementary
            }
            Menu {
                id: powerMenu
                x: parent.width - width
                y: -powerMenu.implicitHeight
                width: 150

                background: Rectangle {
                    color: "#2C2C2C"
                    border.color: "#3F3F3F"
                    border.width: 1
                }

                delegate: MenuItem {
                    id: menuItem
                    width: parent.width
                    height: 36

                    contentItem: Row {
                        spacing: Kirigami.Units.smallSpacing
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 12

                        Kirigami.Icon {
                            source: menuItem.icon.name
                            width: 16; height: 16
                            color: "#FFFFFF"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Text {
                            text: menuItem.text
                            color: "#FFFFFF"
                            font.family: "Segoe UI"
                            font.pixelSize: 14
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    background: Rectangle {
                        color: menuItem.highlighted ? "#33FFFFFF" : "transparent"
                    }
                }

                MenuItem {
                    text: i18ndc("plasma_shell_org.kde.plasma.desktop", "@action:button", "&Sleep")
                    icon.name: "system-suspend"
                    onTriggered: root.suspendToRam()
                    visible: root.suspendToRamSupported
                }
                MenuItem {
                    text: i18ndc("plasma_shell_org.kde.plasma.desktop", "@action:button", "&Shut Down")
                    icon.name: "system-shutdown"
                    enabled: sessionManagement.canShutdown
                    onTriggered: sessionManagement.requestShutdown(SessionManagement.ConfirmationMode.Skip)
                }
                MenuItem {
                    text: i18ndc("plasma_shell_org.kde.plasma.desktop", "@action:button", "&Restart")
                    icon.name: "system-reboot"
                    enabled: sessionManagement.canReboot
                    onTriggered: sessionManagement.requestReboot(SessionManagement.ConfirmationMode.Skip)
                }
            }
            PlasmaComponents3.ToolButton {
                id: powerButton
                width: 32
                height: 32
                icon.name: "system-shutdown"
                icon.color: "#FFFFFF"
                display: AbstractButton.IconOnly
                flat: true
                Kirigami.Theme.inherit: false
                Kirigami.Theme.colorSet: Kirigami.Theme.Complementary
                onClicked: powerMenu.open()
            }
        }
    }

    // ── Clock update timer ──
    Timer {
        interval: 1000; running: true; repeat: true
        onTriggered: {
            var d = new Date();
            timeText.text = Qt.formatTime(d, "HH:mm");
            dateText.text = Qt.formatDate(d, "dddd, MMMM d");
        }
    }
}
