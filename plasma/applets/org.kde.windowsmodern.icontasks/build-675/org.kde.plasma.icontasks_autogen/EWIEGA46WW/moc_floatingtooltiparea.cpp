/****************************************************************************
** Meta object code from reading C++ file 'floatingtooltiparea.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.11.2)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../floatingtooltiparea.h"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'floatingtooltiparea.h' doesn't include <QObject>."
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
struct qt_meta_tag_ZN19FloatingToolTipAreaE_t {};
} // unnamed namespace

template <> constexpr inline auto FloatingToolTipArea::qt_create_metaobjectdata<qt_meta_tag_ZN19FloatingToolTipAreaE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "FloatingToolTipArea",
        "QML.Element",
        "auto",
        "mainItemChanged",
        "",
        "mainTextChanged",
        "subTextChanged",
        "textFormatChanged",
        "iconChanged",
        "imageChanged",
        "containsMouseChanged",
        "locationChanged",
        "activeChanged",
        "interactiveChanged",
        "marginChanged",
        "aboutToShow",
        "toolTipVisibleChanged",
        "toolTipVisible",
        "showToolTip",
        "hideToolTip",
        "hideImmediately",
        "settingsChanged",
        "KConfigGroup",
        "group",
        "QByteArrayList",
        "names",
        "mainItem",
        "QQuickItem*",
        "mainText",
        "subText",
        "textFormat",
        "icon",
        "QVariant",
        "containsMouse",
        "location",
        "Plasma::Types::Location",
        "image",
        "active",
        "interactive",
        "timeout",
        "margin"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'mainItemChanged'
        QtMocHelpers::SignalData<void()>(3, 4, QMC::AccessPublic, QMetaType::Void),
        // Signal 'mainTextChanged'
        QtMocHelpers::SignalData<void()>(5, 4, QMC::AccessPublic, QMetaType::Void),
        // Signal 'subTextChanged'
        QtMocHelpers::SignalData<void()>(6, 4, QMC::AccessPublic, QMetaType::Void),
        // Signal 'textFormatChanged'
        QtMocHelpers::SignalData<void()>(7, 4, QMC::AccessPublic, QMetaType::Void),
        // Signal 'iconChanged'
        QtMocHelpers::SignalData<void()>(8, 4, QMC::AccessPublic, QMetaType::Void),
        // Signal 'imageChanged'
        QtMocHelpers::SignalData<void()>(9, 4, QMC::AccessPublic, QMetaType::Void),
        // Signal 'containsMouseChanged'
        QtMocHelpers::SignalData<void()>(10, 4, QMC::AccessPublic, QMetaType::Void),
        // Signal 'locationChanged'
        QtMocHelpers::SignalData<void()>(11, 4, QMC::AccessPublic, QMetaType::Void),
        // Signal 'activeChanged'
        QtMocHelpers::SignalData<void()>(12, 4, QMC::AccessPublic, QMetaType::Void),
        // Signal 'interactiveChanged'
        QtMocHelpers::SignalData<void()>(13, 4, QMC::AccessPublic, QMetaType::Void),
        // Signal 'marginChanged'
        QtMocHelpers::SignalData<void()>(14, 4, QMC::AccessPublic, QMetaType::Void),
        // Signal 'aboutToShow'
        QtMocHelpers::SignalData<void()>(15, 4, QMC::AccessPublic, QMetaType::Void),
        // Signal 'toolTipVisibleChanged'
        QtMocHelpers::SignalData<void(bool)>(16, 4, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Bool, 17 },
        }}),
        // Slot 'showToolTip'
        QtMocHelpers::SlotData<void()>(18, 4, QMC::AccessPublic, QMetaType::Void),
        // Slot 'hideToolTip'
        QtMocHelpers::SlotData<void()>(19, 4, QMC::AccessPublic, QMetaType::Void),
        // Slot 'hideImmediately'
        QtMocHelpers::SlotData<void()>(20, 4, QMC::AccessPublic, QMetaType::Void),
        // Slot 'settingsChanged'
        QtMocHelpers::SlotData<void(const KConfigGroup &, const QByteArrayList &)>(21, 4, QMC::AccessPrivate, QMetaType::Void, {{
            { 0x80000000 | 22, 23 }, { 0x80000000 | 24, 25 },
        }}),
    };
    QtMocHelpers::UintData qt_properties {
        // property 'mainItem'
        QtMocHelpers::PropertyData<QQuickItem*>(26, 0x80000000 | 27, QMC::DefaultPropertyFlags | QMC::Writable | QMC::EnumOrFlag | QMC::StdCppSet, 0),
        // property 'mainText'
        QtMocHelpers::PropertyData<QString>(28, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 1),
        // property 'subText'
        QtMocHelpers::PropertyData<QString>(29, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 2),
        // property 'textFormat'
        QtMocHelpers::PropertyData<int>(30, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 3),
        // property 'icon'
        QtMocHelpers::PropertyData<QVariant>(31, 0x80000000 | 32, QMC::DefaultPropertyFlags | QMC::Writable | QMC::EnumOrFlag | QMC::StdCppSet, 4),
        // property 'containsMouse'
        QtMocHelpers::PropertyData<bool>(33, QMetaType::Bool, QMC::DefaultPropertyFlags, 6),
        // property 'location'
        QtMocHelpers::PropertyData<Plasma::Types::Location>(34, 0x80000000 | 35, QMC::DefaultPropertyFlags | QMC::Writable | QMC::EnumOrFlag | QMC::StdCppSet, 7),
        // property 'image'
        QtMocHelpers::PropertyData<QVariant>(36, 0x80000000 | 32, QMC::DefaultPropertyFlags | QMC::Writable | QMC::EnumOrFlag | QMC::StdCppSet, 5),
        // property 'active'
        QtMocHelpers::PropertyData<bool>(37, QMetaType::Bool, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 8),
        // property 'interactive'
        QtMocHelpers::PropertyData<bool>(38, QMetaType::Bool, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 9),
        // property 'timeout'
        QtMocHelpers::PropertyData<int>(39, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet),
        // property 'margin'
        QtMocHelpers::PropertyData<int>(40, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 10),
    };
    QtMocHelpers::UintData qt_enums {
    };
    QtMocHelpers::UintData qt_constructors {};
    QtMocHelpers::ClassInfos qt_classinfo({
            {    1,    2 },
    });
    return QtMocHelpers::metaObjectData<FloatingToolTipArea, void>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums, qt_constructors, qt_classinfo);
}
Q_CONSTINIT static const QMetaObject::SuperData qt_meta_extradata_ZN19FloatingToolTipAreaE[] = {
    QMetaObject::SuperData::link<Plasma::Types::staticMetaObject>(),
    nullptr
};

Q_CONSTINIT const QMetaObject FloatingToolTipArea::staticMetaObject = { {
    QMetaObject::SuperData::link<QQuickItem::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN19FloatingToolTipAreaE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN19FloatingToolTipAreaE_t>.data,
    qt_static_metacall,
    qt_meta_extradata_ZN19FloatingToolTipAreaE,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN19FloatingToolTipAreaE_t>.metaTypes,
    nullptr
} };

void FloatingToolTipArea::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<FloatingToolTipArea *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->mainItemChanged(); break;
        case 1: _t->mainTextChanged(); break;
        case 2: _t->subTextChanged(); break;
        case 3: _t->textFormatChanged(); break;
        case 4: _t->iconChanged(); break;
        case 5: _t->imageChanged(); break;
        case 6: _t->containsMouseChanged(); break;
        case 7: _t->locationChanged(); break;
        case 8: _t->activeChanged(); break;
        case 9: _t->interactiveChanged(); break;
        case 10: _t->marginChanged(); break;
        case 11: _t->aboutToShow(); break;
        case 12: _t->toolTipVisibleChanged((*reinterpret_cast<std::add_pointer_t<bool>>(_a[1]))); break;
        case 13: _t->showToolTip(); break;
        case 14: _t->hideToolTip(); break;
        case 15: _t->hideImmediately(); break;
        case 16: _t->settingsChanged((*reinterpret_cast<std::add_pointer_t<KConfigGroup>>(_a[1])),(*reinterpret_cast<std::add_pointer_t<QByteArrayList>>(_a[2]))); break;
        default: ;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (FloatingToolTipArea::*)()>(_a, &FloatingToolTipArea::mainItemChanged, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (FloatingToolTipArea::*)()>(_a, &FloatingToolTipArea::mainTextChanged, 1))
            return;
        if (QtMocHelpers::indexOfMethod<void (FloatingToolTipArea::*)()>(_a, &FloatingToolTipArea::subTextChanged, 2))
            return;
        if (QtMocHelpers::indexOfMethod<void (FloatingToolTipArea::*)()>(_a, &FloatingToolTipArea::textFormatChanged, 3))
            return;
        if (QtMocHelpers::indexOfMethod<void (FloatingToolTipArea::*)()>(_a, &FloatingToolTipArea::iconChanged, 4))
            return;
        if (QtMocHelpers::indexOfMethod<void (FloatingToolTipArea::*)()>(_a, &FloatingToolTipArea::imageChanged, 5))
            return;
        if (QtMocHelpers::indexOfMethod<void (FloatingToolTipArea::*)()>(_a, &FloatingToolTipArea::containsMouseChanged, 6))
            return;
        if (QtMocHelpers::indexOfMethod<void (FloatingToolTipArea::*)()>(_a, &FloatingToolTipArea::locationChanged, 7))
            return;
        if (QtMocHelpers::indexOfMethod<void (FloatingToolTipArea::*)()>(_a, &FloatingToolTipArea::activeChanged, 8))
            return;
        if (QtMocHelpers::indexOfMethod<void (FloatingToolTipArea::*)()>(_a, &FloatingToolTipArea::interactiveChanged, 9))
            return;
        if (QtMocHelpers::indexOfMethod<void (FloatingToolTipArea::*)()>(_a, &FloatingToolTipArea::marginChanged, 10))
            return;
        if (QtMocHelpers::indexOfMethod<void (FloatingToolTipArea::*)()>(_a, &FloatingToolTipArea::aboutToShow, 11))
            return;
        if (QtMocHelpers::indexOfMethod<void (FloatingToolTipArea::*)(bool )>(_a, &FloatingToolTipArea::toolTipVisibleChanged, 12))
            return;
    }
    if (_c == QMetaObject::RegisterPropertyMetaType) {
        switch (_id) {
        default: *reinterpret_cast<int*>(_a[0]) = -1; break;
        case 0:
            *reinterpret_cast<int*>(_a[0]) = qRegisterMetaType< QQuickItem* >(); break;
        }
    }
    if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast<QQuickItem**>(_v) = _t->mainItem(); break;
        case 1: *reinterpret_cast<QString*>(_v) = _t->mainText(); break;
        case 2: *reinterpret_cast<QString*>(_v) = _t->subText(); break;
        case 3: *reinterpret_cast<int*>(_v) = _t->textFormat(); break;
        case 4: *reinterpret_cast<QVariant*>(_v) = _t->icon(); break;
        case 5: *reinterpret_cast<bool*>(_v) = _t->containsMouse(); break;
        case 6: *reinterpret_cast<Plasma::Types::Location*>(_v) = _t->location(); break;
        case 7: *reinterpret_cast<QVariant*>(_v) = _t->image(); break;
        case 8: *reinterpret_cast<bool*>(_v) = _t->m_active; break;
        case 9: *reinterpret_cast<bool*>(_v) = _t->m_interactive; break;
        case 10: *reinterpret_cast<int*>(_v) = _t->m_timeout; break;
        case 11: *reinterpret_cast<int*>(_v) = _t->margin(); break;
        default: break;
        }
    }
    if (_c == QMetaObject::WriteProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: _t->setMainItem(*reinterpret_cast<QQuickItem**>(_v)); break;
        case 1: _t->setMainText(*reinterpret_cast<QString*>(_v)); break;
        case 2: _t->setSubText(*reinterpret_cast<QString*>(_v)); break;
        case 3: _t->setTextFormat(*reinterpret_cast<int*>(_v)); break;
        case 4: _t->setIcon(*reinterpret_cast<QVariant*>(_v)); break;
        case 6: _t->setLocation(*reinterpret_cast<Plasma::Types::Location*>(_v)); break;
        case 7: _t->setImage(*reinterpret_cast<QVariant*>(_v)); break;
        case 8: _t->setActive(*reinterpret_cast<bool*>(_v)); break;
        case 9: _t->setInteractive(*reinterpret_cast<bool*>(_v)); break;
        case 10: _t->setTimeout(*reinterpret_cast<int*>(_v)); break;
        case 11: _t->setMargin(*reinterpret_cast<int*>(_v)); break;
        default: break;
        }
    }
}

const QMetaObject *FloatingToolTipArea::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *FloatingToolTipArea::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN19FloatingToolTipAreaE_t>.strings))
        return static_cast<void*>(this);
    return QQuickItem::qt_metacast(_clname);
}

int FloatingToolTipArea::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QQuickItem::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 17)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 17;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 17)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 17;
    }
    if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::BindableProperty
            || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 12;
    }
    return _id;
}

// SIGNAL 0
void FloatingToolTipArea::mainItemChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void FloatingToolTipArea::mainTextChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}

// SIGNAL 2
void FloatingToolTipArea::subTextChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 2, nullptr);
}

// SIGNAL 3
void FloatingToolTipArea::textFormatChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 3, nullptr);
}

// SIGNAL 4
void FloatingToolTipArea::iconChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 4, nullptr);
}

// SIGNAL 5
void FloatingToolTipArea::imageChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 5, nullptr);
}

// SIGNAL 6
void FloatingToolTipArea::containsMouseChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 6, nullptr);
}

// SIGNAL 7
void FloatingToolTipArea::locationChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 7, nullptr);
}

// SIGNAL 8
void FloatingToolTipArea::activeChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 8, nullptr);
}

// SIGNAL 9
void FloatingToolTipArea::interactiveChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 9, nullptr);
}

// SIGNAL 10
void FloatingToolTipArea::marginChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 10, nullptr);
}

// SIGNAL 11
void FloatingToolTipArea::aboutToShow()
{
    QMetaObject::activate(this, &staticMetaObject, 11, nullptr);
}

// SIGNAL 12
void FloatingToolTipArea::toolTipVisibleChanged(bool _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 12, nullptr, _t1);
}
QT_WARNING_POP
