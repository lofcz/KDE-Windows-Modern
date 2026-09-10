/****************************************************************************
** Meta object code from reading C++ file 'backend.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.11.2)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../backend.h"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'backend.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 69
#error "This file was generated using the moc from 6.11.2. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

#ifndef Q_CONSTINIT
#define Q_CONSTINIT
#endif

QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
QT_WARNING_DISABLE_GCC("-Wuseless-cast")
namespace {
struct qt_meta_tag_ZN7BackendE_t {};
} // unnamed namespace

template <> constexpr inline auto Backend::qt_create_metaobjectdata<qt_meta_tag_ZN7BackendE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "Backend",
        "QML.Element",
        "auto",
        "addLauncher",
        "",
        "QUrl",
        "url",
        "showAllPlaces",
        "aboutToSleep",
        "resumedFromSleep",
        "handleRecentDocumentAction",
        "onPrepareForSleep",
        "sleeping",
        "jumpListActions",
        "QVariantList",
        "launcherUrl",
        "parent",
        "placesActions",
        "recentDocumentActions",
        "setActionGroup",
        "QAction*",
        "action",
        "globalRect",
        "QRect",
        "QQuickItem*",
        "item",
        "isApplication",
        "parentPid",
        "pid",
        "tryDecodeApplicationsUrl",
        "applicationCategories",
        "MiddleClickAction",
        "None",
        "Close",
        "NewInstance",
        "ToggleMinimized",
        "ToggleGrouping",
        "BringToCurrentDesktop"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'addLauncher'
        QtMocHelpers::SignalData<void(const QUrl &) const>(3, 4, QMC::AccessPublic, QMetaType::Void, {{
            { 0x80000000 | 5, 6 },
        }}),
        // Signal 'showAllPlaces'
        QtMocHelpers::SignalData<void()>(7, 4, QMC::AccessPublic, QMetaType::Void),
        // Signal 'aboutToSleep'
        QtMocHelpers::SignalData<void()>(8, 4, QMC::AccessPublic, QMetaType::Void),
        // Signal 'resumedFromSleep'
        QtMocHelpers::SignalData<void()>(9, 4, QMC::AccessPublic, QMetaType::Void),
        // Slot 'handleRecentDocumentAction'
        QtMocHelpers::SlotData<void() const>(10, 4, QMC::AccessPrivate, QMetaType::Void),
        // Slot 'onPrepareForSleep'
        QtMocHelpers::SlotData<void(bool)>(11, 4, QMC::AccessPrivate, QMetaType::Void, {{
            { QMetaType::Bool, 12 },
        }}),
        // Method 'jumpListActions'
        QtMocHelpers::MethodData<QVariantList(const QUrl &, QObject *)>(13, 4, QMC::AccessPublic, 0x80000000 | 14, {{
            { 0x80000000 | 5, 15 }, { QMetaType::QObjectStar, 16 },
        }}),
        // Method 'placesActions'
        QtMocHelpers::MethodData<QVariantList(const QUrl &, bool, QObject *)>(17, 4, QMC::AccessPublic, 0x80000000 | 14, {{
            { 0x80000000 | 5, 15 }, { QMetaType::Bool, 7 }, { QMetaType::QObjectStar, 16 },
        }}),
        // Method 'recentDocumentActions'
        QtMocHelpers::MethodData<QVariantList(const QUrl &, QObject *)>(18, 4, QMC::AccessPublic, 0x80000000 | 14, {{
            { 0x80000000 | 5, 15 }, { QMetaType::QObjectStar, 16 },
        }}),
        // Method 'setActionGroup'
        QtMocHelpers::MethodData<void(QAction *) const>(19, 4, QMC::AccessPublic, QMetaType::Void, {{
            { 0x80000000 | 20, 21 },
        }}),
        // Method 'globalRect'
        QtMocHelpers::MethodData<QRect(QQuickItem *) const>(22, 4, QMC::AccessPublic, 0x80000000 | 23, {{
            { 0x80000000 | 24, 25 },
        }}),
        // Method 'isApplication'
        QtMocHelpers::MethodData<bool(const QUrl &) const>(26, 4, QMC::AccessPublic, QMetaType::Bool, {{
            { 0x80000000 | 5, 6 },
        }}),
        // Method 'parentPid'
        QtMocHelpers::MethodData<qint64(qint64) const>(27, 4, QMC::AccessPublic, QMetaType::LongLong, {{
            { QMetaType::LongLong, 28 },
        }}),
        // Method 'tryDecodeApplicationsUrl'
        QtMocHelpers::MethodData<QUrl(const QUrl &)>(29, 4, QMC::AccessPublic, 0x80000000 | 5, {{
            { 0x80000000 | 5, 15 },
        }}),
        // Method 'applicationCategories'
        QtMocHelpers::MethodData<QStringList(const QUrl &)>(30, 4, QMC::AccessPublic, QMetaType::QStringList, {{
            { 0x80000000 | 5, 15 },
        }}),
    };
    QtMocHelpers::UintData qt_properties {
    };
    QtMocHelpers::UintData qt_enums {
        // enum 'MiddleClickAction'
        QtMocHelpers::EnumData<enum MiddleClickAction>(31, 31, QMC::EnumFlags{}).add({
            {   32, MiddleClickAction::None },
            {   33, MiddleClickAction::Close },
            {   34, MiddleClickAction::NewInstance },
            {   35, MiddleClickAction::ToggleMinimized },
            {   36, MiddleClickAction::ToggleGrouping },
            {   37, MiddleClickAction::BringToCurrentDesktop },
        }),
    };
    QtMocHelpers::UintData qt_constructors {};
    QtMocHelpers::ClassInfos qt_classinfo({
            {    1,    2 },
    });
    return QtMocHelpers::metaObjectData<Backend, void>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums, qt_constructors, qt_classinfo);
}
Q_CONSTINIT const QMetaObject Backend::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN7BackendE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN7BackendE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN7BackendE_t>.metaTypes,
    nullptr
} };

void Backend::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<Backend *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->addLauncher((*reinterpret_cast<std::add_pointer_t<QUrl>>(_a[1]))); break;
        case 1: _t->showAllPlaces(); break;
        case 2: _t->aboutToSleep(); break;
        case 3: _t->resumedFromSleep(); break;
        case 4: _t->handleRecentDocumentAction(); break;
        case 5: _t->onPrepareForSleep((*reinterpret_cast<std::add_pointer_t<bool>>(_a[1]))); break;
        case 6: { QVariantList _r = _t->jumpListActions((*reinterpret_cast<std::add_pointer_t<QUrl>>(_a[1])),(*reinterpret_cast<std::add_pointer_t<QObject*>>(_a[2])));
            if (_a[0]) *reinterpret_cast<QVariantList*>(_a[0]) = std::move(_r); }  break;
        case 7: { QVariantList _r = _t->placesActions((*reinterpret_cast<std::add_pointer_t<QUrl>>(_a[1])),(*reinterpret_cast<std::add_pointer_t<bool>>(_a[2])),(*reinterpret_cast<std::add_pointer_t<QObject*>>(_a[3])));
            if (_a[0]) *reinterpret_cast<QVariantList*>(_a[0]) = std::move(_r); }  break;
        case 8: { QVariantList _r = _t->recentDocumentActions((*reinterpret_cast<std::add_pointer_t<QUrl>>(_a[1])),(*reinterpret_cast<std::add_pointer_t<QObject*>>(_a[2])));
            if (_a[0]) *reinterpret_cast<QVariantList*>(_a[0]) = std::move(_r); }  break;
        case 9: _t->setActionGroup((*reinterpret_cast<std::add_pointer_t<QAction*>>(_a[1]))); break;
        case 10: { QRect _r = _t->globalRect((*reinterpret_cast<std::add_pointer_t<QQuickItem*>>(_a[1])));
            if (_a[0]) *reinterpret_cast<QRect*>(_a[0]) = std::move(_r); }  break;
        case 11: { bool _r = _t->isApplication((*reinterpret_cast<std::add_pointer_t<QUrl>>(_a[1])));
            if (_a[0]) *reinterpret_cast<bool*>(_a[0]) = std::move(_r); }  break;
        case 12: { qint64 _r = _t->parentPid((*reinterpret_cast<std::add_pointer_t<qint64>>(_a[1])));
            if (_a[0]) *reinterpret_cast<qint64*>(_a[0]) = std::move(_r); }  break;
        case 13: { QUrl _r = _t->tryDecodeApplicationsUrl((*reinterpret_cast<std::add_pointer_t<QUrl>>(_a[1])));
            if (_a[0]) *reinterpret_cast<QUrl*>(_a[0]) = std::move(_r); }  break;
        case 14: { QStringList _r = _t->applicationCategories((*reinterpret_cast<std::add_pointer_t<QUrl>>(_a[1])));
            if (_a[0]) *reinterpret_cast<QStringList*>(_a[0]) = std::move(_r); }  break;
        default: ;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (Backend::*)(const QUrl & ) const>(_a, &Backend::addLauncher, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (Backend::*)()>(_a, &Backend::showAllPlaces, 1))
            return;
        if (QtMocHelpers::indexOfMethod<void (Backend::*)()>(_a, &Backend::aboutToSleep, 2))
            return;
        if (QtMocHelpers::indexOfMethod<void (Backend::*)()>(_a, &Backend::resumedFromSleep, 3))
            return;
    }
}

const QMetaObject *Backend::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *Backend::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN7BackendE_t>.strings))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int Backend::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 15)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 15;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 15)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 15;
    }
    return _id;
}

// SIGNAL 0
void Backend::addLauncher(const QUrl & _t1)const
{
    QMetaObject::activate<void>(const_cast< Backend *>(this), &staticMetaObject, 0, nullptr, _t1);
}

// SIGNAL 1
void Backend::showAllPlaces()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}

// SIGNAL 2
void Backend::aboutToSleep()
{
    QMetaObject::activate(this, &staticMetaObject, 2, nullptr);
}

// SIGNAL 3
void Backend::resumedFromSleep()
{
    QMetaObject::activate(this, &staticMetaObject, 3, nullptr);
}
QT_WARNING_POP
