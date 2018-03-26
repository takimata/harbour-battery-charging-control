# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-battery-charging-control

# removing sailfishapp_i18n will disable building translations every time
CONFIG += sailfishapp c++11 sailfishapp_i18n

HEADERS += src/controllerModel.h

SOURCES += src/harbour-battery-charging-control.cpp \
    src/controllerModel.cpp

DISTFILES += qml/harbour-battery-charging-control.qml \
    qml/cover/CoverPage.qml \
    qml/pages/AutomaticMode.qml \
    qml/pages/ManualMode.qml \
    qml/pages/Error.qml \
    translations/*.ts \
    images/background.png \
    harbour-battery-charging-control.desktop \
    harbour-battery-charging-control.pro.user

SAILFISHAPP_ICONS = 86x86 108x108 128x128

LIBS += -lkeepalive

QT += dbus

#helperstuff.files += ../helpers/enableCharging/enableCharging ../helpers/disableCharging/disableCharging
#helperstuff.path = /usr/share/$${TARGET}/helpers

# workaround
# because of the special build system used by Sailfish IDE it's either necessary to copy theses files directly or manually try to build everything twice before you finally get the .rpm
# (for whatever reason, I don't know why - please tell me the fix if you know it.)
helperstuffWorkaround.files += ../helpers/enableCharging/enableCharging ../helpers/disableCharging/disableCharging
helperstuffWorkaround.path = /usr/share/$${TARGET}/helpers
unix:helperstuffWorkaround.extra = $$QMAKE_COPY $${helperstuffWorkaround.files} /home/deploy/installroot$${helperstuffWorkaround.path}

coverimage.files = images
coverimage.path = /usr/share/$${TARGET}/

INSTALLS += coverimage helperstuffWorkaround

PKGCONFIG += contextkit-statefs

# btw, localized app name is in the .desktop file
TRANSLATIONS += translations/harbour-battery-charging-control-de.ts

OTHER_FILES += icons/generateIcons.sh icons/icon.svg

# if you want autocomplete for libkeepalive, ...; copy their headers over there
# e.g. ~/SailfishOS/mersdk/targets/SailfishOS-2.1.4.13-armv7hl/usr/include/
INCLUDEPATH += "$${MER_SSH_SHARED_TARGET}$${MER_SSH_TARGET_NAME}/usr/include/"
