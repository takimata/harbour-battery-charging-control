import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent

        Column{
            width: parent.width
            anchors.verticalCenter: parent.verticalCenter
            spacing: Theme.paddingLarge

            Label {
                width: parent.width
                font.pixelSize: Theme.fontSizeLarge
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("Something went wrong during startup.")
                wrapMode: Text.Wrap
            }
        }
    }
}
