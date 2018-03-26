#ifndef CONTROLLERMODEL_H
#define CONTROLLERMODEL_H

#include <QtCore>
#include <QMap>
#include <QSettings>
#include <contextproperty.h>
#include <keepalive/backgroundactivity.h>

#include <QtDebug>

const QString BCC_SettingsKey_Auto = QStringLiteral("AutomaticMode");
const QString BCC_SettingsKey_upperLimit = QStringLiteral("StopChargingAt");

class ControllerModel : public QObject {
    Q_OBJECT

    Q_PROPERTY(uint upperLimit READ getUpperLimit WRITE setUpperLimit NOTIFY upperLimitChanged)
    Q_PROPERTY(uint currentValue READ getCurrentValue NOTIFY currentValueChanged)
    Q_PROPERTY(bool charging READ isCharging WRITE enableCharging NOTIFY isChargingChanged)
    Q_PROPERTY(bool automaticMode READ getAutomaticMode WRITE setAutomaticMode NOTIFY automaticModeChanged)

    private slots:
    void handleBatteryLevelChange();
    void handlePowerSupplyPresentChange();
    void handleIsChargingChanged();
    void backgroundActivity();

    private:
    enum ChargingState {Unknown, Charging, Discharging, Idle};
    ChargingState chargingState = ChargingState::Unknown;

    QMap<QString, ChargingState> chargingStateMapping = {std::make_pair("unknown", ChargingState::Unknown),
                                                     std::make_pair("charging", ChargingState::Charging),
                                                     std::make_pair("discharging", ChargingState::Discharging),
                                                     std::make_pair("idle", ChargingState::Idle)};

    ContextProperty *batteryLevel;
    ContextProperty *runningOnBattery;
    ContextProperty *chargingStateMonitor;

    uint upperLimit = 70, currentValue = 0;
    bool automaticMode = true;

    // https://git.merproject.org/mer-core/nemo-keepalive/blob/12a1528bacd20e0a07e9bbcbc287b08641986265/lib/backgroundactivity.h
    BackgroundActivity chargeActivity;

    // is there a better way instead of hardcoding the path?
    QString dataDir = "/usr/share/" + QCoreApplication::applicationName();
    QSettings settings;

    void applyChargingPolicy();
    void allowDeepSuspend(bool deepSuspendAllowed);
    void readSettings();

    int limitValue(int value) {
        if (value < 0) {
            return 0;
        }
        else if (value > 100) {
            return 100;
        }
        else {
            return value;
        }
    }

    public slots:
    void writeSettings();

    public:
    explicit ControllerModel(QObject *parent = 0);

    bool isCharging() {
        return (chargingState == ChargingState::Charging);
    }

    bool getAutomaticMode() {
        return automaticMode;
    }

    uint getUpperLimit() const {
        return upperLimit;
    }
    uint getCurrentValue() const {
        return currentValue;
    }

    int enableCharging(bool enable);
    void setAutomaticMode(bool v);
    void setUpperLimit(uint value);
    void setCurrentValue(uint value);

    ~ControllerModel() {
        delete batteryLevel;
        delete runningOnBattery;
        delete chargingStateMonitor;
    }

    signals:
    void upperLimitChanged();
    void currentValueChanged();
    void isChargingChanged();
    void automaticModeChanged();
};

#endif  // CONTROLLERMODEL_H
