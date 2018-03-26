import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.Layouts 1.1

Page {
    allowedOrientations: Orientation.All
    //if this page is loaded/active, we are in automatic mode, otherwise manual operation
    Component.onCompleted: cppModel.automaticMode = true
    Component.onDestruction: cppModel.automaticMode = false

    SilicaFlickable {
        anchors.fill: parent
        PullDownMenu {
            MenuItem {
                text: qsTr("Manual mode")
                onClicked: pageStack.replaceAbove(null, Qt.resolvedUrl("ManualMode.qml"), null, PageStackAction.Immediate)
            }
        }

        PageHeader {
            title: qsTr("Automatic charging control")
        }

        Column{
            width: parent.width
            anchors.verticalCenter: parent.verticalCenter
            spacing: Theme.paddingLarge

            Label {
                width: parent.width - 2* Theme.horizontalPageMargin
                wrapMode: Text.Wrap
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Charging will be automatically disabled if the battery level reaches the upper limit and enabled if it drops below this limit.")
            }

            Slider {
                id: sliderUpperLimit
                label: qsTr("Upper Limit")
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                //I think 50% instead of 0% as minimal limit is reasonable
                //rationale: smaller range allows faster value selection
                minimumValue: 50; maximumValue: 100; stepSize: 1
                // set initial value
                Component.onCompleted: value = cppModel.upperLimit
                valueText: value + "%"
                onReleased: cppModel.upperLimit = this.value
            }

            Label {
                font.pixelSize: Theme.fontSizeLarge
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Current level: ") + cppModel.currentValue + "%"
                id: labelCurrentValue
            }

            Slider {
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                enabled: false
                handleVisible: false
                minimumValue: 0; maximumValue: 100; stepSize: 1
                value: cppModel.currentValue
                label: qsTr("Current battery level")
            }

            Label {
                width: parent.width - 2 * Theme.horizontalPageMargin
                wrapMode: Text.Wrap
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("The external power source will continue to feed your device - only battery charging will be affected.")
                visible: !cppModel.charging
            }
        }
    }
}
