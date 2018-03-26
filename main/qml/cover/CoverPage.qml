import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {

    Image {
        // svg not supported
        source: "../../images/background.png"
        anchors {
            verticalCenter: parent.verticalCenter

            top: parent.top
            topMargin: Theme.paddingMedium

            right: parent.right
            rightMargin: Theme.paddingMedium
        }
        fillMode: Image.PreserveAspectFit
        opacity: 0.3
    }

    Column{
        width: parent.width
        anchors.verticalCenter: parent.verticalCenter
        spacing: Theme.paddingLarge

        Label {
            font.pixelSize: Theme.fontSizeLarge
            anchors.horizontalCenter: parent.horizontalCenter
            text: cppModel.charging? qsTr("Charging") : qsTr("Discharging")
        }

        Label {
            font.pixelSize: Theme.fontSizeLarge
            anchors.horizontalCenter: parent.horizontalCenter
            text: cppModel.currentValue + "%"
        }

        Label {
            //just for spacing
            font.pixelSize: Theme.fontSizeLarge
            anchors.horizontalCenter: parent.horizontalCenter
            visible: cppModel.charging
            text: " "
        }

        Label {
            font.pixelSize: Theme.fontSizeLarge
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Limit: ")
            visible: cppModel.charging & cppModel.automaticMode
        }

        Label {
            font.pixelSize: Theme.fontSizeLarge
            anchors.horizontalCenter: parent.horizontalCenter
            text: cppModel.upperLimit + "%"
            visible: cppModel.charging & cppModel.automaticMode
        }
    }
}
