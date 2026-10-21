/*
    SPDX-FileCopyrightText: 2013 Sebastian Kügler <sebas@kde.org>
    SPDX-License-Identifier: GPL-2.0-or-later
*/

#ifndef FLOATINGTOOLTIPDIALOG_H
#define FLOATINGTOOLTIPDIALOG_H

#include <PlasmaQuick/PopupPlasmaWindow>

#include <QQuickWindow>
#include <QTimer>
#include <QVariant>

#include <plasma_version.h>

#include <memory>

class QQuickItem;
class QQmlEngine;

#if PLASMA_VERSION < QT_VERSION_CHECK(6, 8, 0)
namespace PlasmaQuick
{
class SharedQmlEngine;
}
#endif

class FloatingToolTipDialog : public PlasmaQuick::PopupPlasmaWindow
{
    Q_OBJECT

public:
    explicit FloatingToolTipDialog();
    ~FloatingToolTipDialog() override;

    QQuickItem *loadDefaultItem();

    void dismiss();
    void keepalive();
    void syncSize();

    bool interactive();
    void setInteractive(bool interactive);

    int hideTimeout() const;
    void setHideTimeout(int timeout);

    QObject *owner() const;
    void setOwner(QObject *owner);

protected:
    void showEvent(QShowEvent *event) override;
    void hideEvent(QHideEvent *event) override;
    bool event(QEvent *e) override;

private Q_SLOTS:
    void valueChanged(const QVariant &value);

private:
    void updateSize();

    QPointer<QQuickItem> m_lastMainItem;
#if PLASMA_VERSION >= QT_VERSION_CHECK(6, 8, 0)
    std::shared_ptr<QQmlEngine> m_engine;
    std::unique_ptr<QQuickItem> m_qmlObject;
#else
    PlasmaQuick::SharedQmlEngine *m_qmlObject;
#endif
    QTimer m_hideTimer;
    int m_hideTimeout;
    bool m_interactive;
    QObject *m_owner;
};

#endif
