import QtQuick 2.2
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 

PlasmoidItem {

    id : root 

    property bool containmentItemAvailable : true
    property ContainmentItem containmentItem : null
    readonly property int depth : 14
    readonly property var helpMessage : "This Applet is intented for panel"
    readonly property bool editMode : containmentItem.Plasmoid.containment.corona.editMode
    // auto toggles at startup
    Component.onCompleted: initializeAppletTimer.start()
    // hides the button in system tray when not in edit mode
    Plasmoid.status: !editMode ? PlasmaCore.Types.HiddenStatus : PlasmaCore.Types.PassiveStatus

    Button {
        id : transparencyButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        visible : editMode
        onClicked : toggleTransparency()
    }

    Label {
        id : helpMessageLabel
        anchors.horizontalCenter : parent.horizontalCenter
        anchors.verticalCenter : parent.verticalCenter
        visible : containmentItem == null
        text : root.helpMessage
    }

    function toggleTransparency() {
        if ( root.containmentItem == null ) lookForContainer( root.parent , depth ) ;
        if ( root.containmentItem != null ) {
            root.containmentItem.Plasmoid.backgroundHints = (root.containmentItem.Plasmoid.backgroundHints.toString().indexOf("1") > -1 ) ? PlasmaCore.Types.NoBackground : PlasmaCore.Types.DefaultBackground ;
        }
    }

    function lookForContainer( object , tries ) {
        if ( tries == 0 || object == null ) return ;
        if ( object.toString().indexOf("ContainmentItem_QML") > -1 ) {
            root.containmentItem = object ;
            console.log( "ContainmentItemFound At " + ( depth - tries ) + " recursive call" ) ;
        } else {
            lookForContainer( object.parent , tries-1 ) ;
        }
    }

    Timer {
        id: initializeAppletTimer
        interval: 1200

        property int step: 0

        readonly property int maxStep:4

        onTriggered: {
            console.log("enabling transparency mode attempt : " + (step+1) )
            root.toggleTransparency()
            if ( root.containmentItem == null && step<maxStep ) {
                step = step + 1;
                start();
            }
        }

    }

}