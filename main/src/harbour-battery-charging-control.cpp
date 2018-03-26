#include <QtQuick>
#include <QObject>
#include <sailfishapp.h>
#include <QQmlEngine>
#include <QScopedPointer>
#include "controllerModel.h"

int main(int argc, char *argv[]) {
    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
    QScopedPointer<QQuickView> view(SailfishApp::createView());

    ControllerModel cm;
    view->rootContext()->setContextProperty("cppModel", &cm);
    QObject::connect(app.data(), SIGNAL(aboutToQuit()), &cm, SLOT(writeSettings()));

    view->setSource(SailfishApp::pathTo("qml/harbour-battery-charging-control.qml"));
    view->show();
    return app->exec();
}
