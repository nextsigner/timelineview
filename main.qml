import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14

import TimeLineView 1.0

ApplicationWindow {
    id: app
    x:0
    y:0
    width: app.portrait?608:Screen.width
    height: Screen.height
    visible: true
    title: "Zool LT"
    color: "black"
    flags: Qt.FramelessWindowHint



    property int fs: app.portrait?xApp.width*0.06:Screen.width*0.02
    property bool portrait: true
    Item{
        id: apps
        property color backgroundColor: 'black'
        property color fontColor: 'white'
    }
    Rectangle {
        id: xApp
        color: 'transparent'
        border.width: 1
        border.color: 'red'
        anchors.fill: parent

        // Instancia de nuestro componente personalizado
        TimeLineView {
            id: timeline
            //anchors.centerIn: parent
            width: parent.width-app.fs*0.2
            height: parent.height-app.fs*0.2
            anchors.centerIn: parent
            //z: parent.z-1
        }

        // Botonera de control inferior para avanzar y retroceder
        Row {
            anchors.top: timeline.bottom
            anchors.topMargin: 20
            //anchors.centerX: parent.centerX
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 20

            Button {
                text: "◀ Atrás"
                enabled: timeline.currentIndex > 0
                onClicked: timeline.back()
            }

            // Indicador de posición actual
            Text {
                text: (timeline.count > 0) ? (timeline.currentIndex + 1) + " / " + timeline.count : "0 / 0"
                color: "#eeeeee"
                font.pointSize: 12
                anchors.verticalCenter: parent.verticalCenter
            }

            Button {
                text: "Adelante ▶"
                enabled: timeline.currentIndex < timeline.count - 1
                onClicked: timeline.next()
            }
        }
    }

    // Simulación de carga de datos JSON al iniciar la app
    Component.onCompleted: {
        var jsonTestData = JSON.parse(u.getFile('./jsons/trans_pluton.json'))

        // Convertimos el array de objetos a string JSON para simular el comportamiento real
        var jsonString = JSON.stringify(jsonTestData);

        //Cargamos los datos en el componente
        timeline.loadData(jsonString);
    }
    Shortcut{
        sequence: 'Esc'
        onActivated: Qt.quit()
    }
    Shortcut{
        sequence: 'Ctrl+Down'
        onActivated: app.y+=10
    }
    Shortcut{
        sequence: 'Left'
        onActivated: timeline.back()
    }
    Shortcut{
        sequence: 'Right'
        onActivated: timeline.next()
    }
}
