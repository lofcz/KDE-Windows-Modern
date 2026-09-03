/***************************************************************************
 *   License: GPL-3.0-or-later
 *   Author: Jeysef
 *
 *   Windows 11-style power flyout. In-dialog so hideOnWindowDeactivate
 *   does not close the start menu.
 ***************************************************************************/

import QtQuick
import QtQuick.Layouts

import org.kde.plasma.private.sessions
import org.kde.kirigami as Kirigami

Item {
    id: root

    property Item visualParent
    readonly property bool opened: popup.visible

    signal closed

    SessionManagement { id: sessionManager }

    function triggerShutdown() {
        if (sessionManager.canShutdown) {
            sessionManager.requestShutdown()
        }
    }

    MouseArea {
        id: clickCatcher
        anchors.fill: parent
        visible: popup.visible
        z: 90
        onClicked: root.close()
    }

    Rectangle {
        id: popup
        visible: false
        z: 100

        width: Kirigami.Units.gridUnit * 11
        height: powerColumn.implicitHeight + 12
        radius: 8
        color: "#2C2C2C"
        border.width: 1
        border.color: "#3F3F3F"

        Column {
            id: powerColumn
            width: popup.width - 8
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 6
            spacing: 2

            // Win11 Start power flyout: Sleep, Shut down, Restart
            PowerOption {
                iconSource: "system-suspend"
                label: i18n("Sleep")
                optionEnabled: sessionManager.canSuspend
                onActivated: {
                    sessionManager.suspend()
                    root.close()
                }
            }

            PowerOption {
                iconSource: "system-shutdown"
                label: i18n("Shut down")
                optionEnabled: sessionManager.canShutdown
                onActivated: {
                    sessionManager.requestShutdown()
                    root.close()
                }
            }

            PowerOption {
                iconSource: "system-reboot"
                label: i18n("Restart")
                optionEnabled: sessionManager.canReboot
                onActivated: {
                    sessionManager.requestReboot()
                    root.close()
                }
            }

            Rectangle {
                width: powerColumn.width - 16
                height: 1
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#3F3F3F"
            }

            PowerOption {
                iconSource: "system-lock-screen"
                label: i18n("Lock")
                optionEnabled: sessionManager.canLock
                onActivated: {
                    sessionManager.lock()
                    root.close()
                }
            }

            PowerOption {
                iconSource: "system-log-out"
                label: i18n("Sign out")
                optionEnabled: sessionManager.canLogout
                onActivated: {
                    sessionManager.requestLogout()
                    root.close()
                }
            }
        }
    }

    function open() {
        if (!root.visualParent) return

        var popupW = popup.width
        var popupH = popup.height
        var gap = 6

        var pos = root.visualParent.mapToItem(root, root.visualParent.width - popupW, -popupH - gap)

        if (pos.y < gap) {
            pos.y = root.visualParent.mapToItem(root, 0, root.visualParent.height + gap).y
        }

        pos.x = Math.max(gap, Math.min(pos.x, root.width - popupW - gap))

        popup.x = pos.x
        popup.y = pos.y
        popup.visible = true
    }

    function close() {
        popup.visible = false
        root.closed()
    }
}
