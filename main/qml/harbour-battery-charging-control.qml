import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"

ApplicationWindow
{
    Component {
        id: automaticMode
        AutomaticMode{}
    }
    Component {
        id: manualMode
        ManualMode{}
    }

    initialPage:  cppModel.automaticMode ? automaticMode : manualMode
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations
}
