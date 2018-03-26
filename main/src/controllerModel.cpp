#include <QtDebug>
#include <QtDBus/QtDBus>
#include <QDBusMessage>
#include <QDBusVariant>
#include <QList>

#include "controllerModel.h"

ControllerModel::ControllerModel(QObject *parent) :
    QObject(parent),

    // see https://git.merproject.org/mer-core/statefs-providers/blob/master/src/power_udev/provider_power_udev.cpp
    batteryLevel(new ContextProperty("Battery.ChargePercentage", this)),      // x \in [0, 100]
    chargingStateMonitor(new ContextProperty("Battery.ChargingState", this)), // x \in {unknown, charging, discharging, idle}
    chargerType(new ContextProperty("Battery.ChargerType", this)),            // x \in {usb, dcp, hvdcp, cdp, unknown, "" -> absent}
    chargeActivity(this),
    settings(QSettings::UserScope, QCoreApplication::applicationName(), QCoreApplication::applicationName(), this) {

    readSettings();

    connect(batteryLevel, SIGNAL(valueChanged()), this, SLOT(handleBatteryLevelChange()));
    connect(chargingStateMonitor, SIGNAL(valueChanged()), this, SLOT(handleIsChargingChanged()));
    connect(chargerType, SIGNAL(valueChanged()), this, SLOT(handlePowerSupplyPresentChange()));

    chargeActivity.setWakeupFrequency(BackgroundActivity::TenMinutes);
    connect(&chargeActivity, SIGNAL(running()), this, SLOT(backgroundActivity()));
}

int ControllerModel::enableCharging(bool enable) {
    qDebug() << "Charging enabled: " << enable;

    if (enable)
        return system((dataDir + "/helpers/enableCharging").toLatin1().data());
    else
        return system((dataDir + "/helpers/disableCharging").toLatin1().data());
}

void ControllerModel::readSettings() {
    setAutomaticMode(settings.value(BCC_SettingsKey_Auto, QVariant(true)).toBool());
    setUpperLimit(settings.value(BCC_SettingsKey_upperLimit, QVariant(70)).toUInt());
}

void ControllerModel::writeSettings() {
    settings.setValue(BCC_SettingsKey_Auto, automaticMode);
    settings.setValue(BCC_SettingsKey_upperLimit, upperLimit);

    settings.sync();
}

void ControllerModel::backgroundActivity() {
    applyChargingPolicy();
}

/** Enables or disables charging depending on the current state
 * @brief ControllerModel::applyChargingPolicy
 */
void ControllerModel::applyChargingPolicy() {
    if (automaticMode) {
        if (currentValue >= upperLimit) {
            enableCharging(false);
            chargeActivity.stop();
        }
        else {
            enableCharging(true);
            chargeActivity.wait();
        }
    }
}

void ControllerModel::handleIsChargingChanged() {
    qDebug() << "Charging State: " << chargingStateMonitor->value().value<QString>();
    ChargingState newValue = chargingStateMapping.value(chargingStateMonitor->value().value<QString>(), ChargingState::Unknown);

    if (newValue != chargingState) {
        chargingState = newValue;
        emit isChargingChanged();
    }
}

void ControllerModel::handleBatteryLevelChange() {
    setCurrentValue(batteryLevel->value().toInt());
}

void ControllerModel::handlePowerSupplyPresentChange() {
    qDebug() << "Charger type: " << chargerType->value().value<QString>();

    if (chargerType->value().value<QString>().isEmpty()) {
        // empty charger type means no power source
        chargeActivity.wait();
    }
    else {

        chargeActivity.stop();
        applyChargingPolicy();
    }
    emit chargerConnectedChanged();
}

void ControllerModel::setAutomaticMode(bool value) {
    if (value != automaticMode) {
        automaticMode = value;
        emit automaticModeChanged();
        applyChargingPolicy();
    }
}

void ControllerModel::setUpperLimit(uint value) {
    if (upperLimit == value) {
        return;
    }

    value = limitValue(value);

    upperLimit = value;
    applyChargingPolicy();
    emit upperLimitChanged();
}

void ControllerModel::setCurrentValue(uint value) {
    value = limitValue(value);
    if (currentValue == value) {
        return;
    }
    currentValue = value;
    applyChargingPolicy();
    emit currentValueChanged();
}
