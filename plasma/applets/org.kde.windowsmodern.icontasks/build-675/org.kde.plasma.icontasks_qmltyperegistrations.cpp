/****************************************************************************
** Generated QML type registration code
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include <QtQml/qqml.h>
#include <QtQml/qqmlmoduleregistration.h>

#if __has_include(<backend.h>)
#  include <backend.h>
#endif
#if __has_include(<floatingtooltiparea.h>)
#  include <floatingtooltiparea.h>
#endif
#if __has_include(<smartlauncheritem.h>)
#  include <smartlauncheritem.h>
#endif


#if !defined(QT_STATIC)
#define Q_QMLTYPE_EXPORT Q_DECL_EXPORT
#else
#define Q_QMLTYPE_EXPORT
#endif
Q_QMLTYPE_EXPORT void qml_register_types_plasma_applet_org_kde_plasma_icontasks()
{
    qmlRegisterModule("plasma.applet.org.kde.plasma.icontasks", 254, 0);
    QT_WARNING_PUSH QT_WARNING_DISABLE_DEPRECATED
    qmlRegisterTypesAndRevisions<Backend>("plasma.applet.org.kde.plasma.icontasks", 254);
    qmlRegisterEnum<Backend::MiddleClickAction>("Backend::MiddleClickAction");
    qmlRegisterTypesAndRevisions<FloatingToolTipArea>("plasma.applet.org.kde.plasma.icontasks", 254);
    qmlRegisterAnonymousType<QQuickItem, 254>("plasma.applet.org.kde.plasma.icontasks", 254);
    qmlRegisterTypesAndRevisions<SmartLauncher::Item>("plasma.applet.org.kde.plasma.icontasks", 254);
    QT_WARNING_POP
    qmlRegisterModule("plasma.applet.org.kde.plasma.icontasks", 254, 254);
}

static const QQmlModuleRegistration plasmaappletorgkdeplasmaicontasksRegistration("plasma.applet.org.kde.plasma.icontasks", qml_register_types_plasma_applet_org_kde_plasma_icontasks);
