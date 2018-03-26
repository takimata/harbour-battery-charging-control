import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: pageManualMode
    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("Automatic mode")
                onClicked: pageStack.replaceAbove(null, Qt.resolvedUrl("AutomaticMode.qml"), null, PageStackAction.Immediate)
            }
        }
        PageHeader {
            title: qsTr("Manual charging control")
        }

        Column{
            width: parent.width
            anchors.verticalCenter: parent.verticalCenter
            spacing: Theme.paddingLarge

            Label {
                width: parent.width - 2 * Theme.horizontalPageMargin
                wrapMode: Text.Wrap
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("The external power source will continue to feed your device - only battery charging will be affected.")
                visible: !cppModel.charging
            }

            //no TextSwitch on purpose, I think a button looks better here
            Button{
                anchors.horizontalCenter: parent.horizontalCenter
                text: cppModel.charging ? qsTr("Disable charging") : qsTr("Enable charging")
                preferredWidth: Theme.buttonWidthLarge
                onClicked: cppModel.charging = !cppModel.charging
            }
        }
    }
}
