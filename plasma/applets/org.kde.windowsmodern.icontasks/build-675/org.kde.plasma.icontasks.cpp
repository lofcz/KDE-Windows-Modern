
#include <KPluginFactory>
#include <Plasma/Applet>

class org_kde_plasma_icontasks_Plugin : public Plasma::Applet {
   Q_OBJECT
public:
   org_kde_plasma_icontasks_Plugin(QObject *parent, const KPluginMetaData &data, const QVariantList &args)
      : Plasma::Applet(parent, data, args) {}
};

K_PLUGIN_CLASS_WITH_JSON(org_kde_plasma_icontasks_Plugin, "metadata.json")

#include "org.kde.plasma.icontasks.moc"
