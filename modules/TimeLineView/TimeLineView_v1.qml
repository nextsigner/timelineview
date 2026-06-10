import QtQuick 2.14
import QtQuick.Controls 2.14

Rectangle {
    id: r
    //implicitWidth: 600
    //implicitHeight: 220 // Incrementado ligeramente para acomodar los nuevos datos
    color: "#1e1e24"
    radius: 8
    clip: true

    property int wi: r.width / 3.5

    readonly property alias currentIndex: timelineList.currentIndex
    readonly property alias count: timelineList.count

    property string d0: 'Título Global'
    property string d00: 'Des Global'
    property string d1: 'Dato 1'
    property string d2: 'Dato 2'
    property string d3: 'Dato 3'


    Column{
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        Column{
            id: colGlobalCtx
            spacing: app.fs*0.25
            Text{
                id: globalTitle
                text: r.d0
                width: r.width-app.fs
                font.pixelSize: app.fs
                color: apps.fontColor
                wrapMode: Text.WordWrap
            }
            Text{
                id: globalCtx
                text: r.d00
                width: r.width-app.fs
                font.pixelSize: app.fs*0.5
                color: apps.fontColor
                wrapMode: Text.WordWrap
            }
        }
        ListView {
            id: timelineList
            width: r.width
            height: app.fs*8
            //anchors.fill: parent
            model: nodesModel
            orientation: ListView.Horizontal
            spacing: 0
            //z: 2

            snapMode: ListView.SnapToItem
            highlightRangeMode: ListView.ApplyRange
            preferredHighlightBegin: width / 2 - (r.implicitWidth / 3.5) / 2
            preferredHighlightEnd: width / 2 + (r.implicitWidth / 3.5) / 2
            highlightMoveDuration: 300

            delegate: Item {
                id: delegateItem
                // Ajustamos el ancho para dar un poco más de aire a los datos detallados
                //width: r.width / 3.5
                width: r.wi
                height: timelineList.height

                property bool isSelected: index === timelineList.currentIndex
                onIsSelectedChanged: {
                    if(isSelected){
                        let strGmt=''
                        if(model.gmt>0){
                            strGmt='+'+model.gmt
                        }else if(model.gmt<0){
                            strGmt='-'+model.gmt
                        }else{
                            strGmt=''+model.gmt
                        }
                        r.d1=""+pad(model.day) + "/" + pad(model.month) + "/" + model.year+" "+pad(model.hour) + ":" + pad(model.minute) + " (GMT " + strGmt + ")\nLugar: "+model.place+"\n"+
                                "Lat: " + nodesModel.get(timelineList.currentIndex).lat.toFixed(4) + "°  |  " +
                                "Lon: " + nodesModel.get(timelineList.currentIndex).lon.toFixed(4) + "°  |  " +
                                "Alt: " + nodesModel.get(timelineList.currentIndex).alt + "m"

                        r.d2=model.title
                        r.d3=model.description
                    }
                }

                // Nodo (Círculo)
                Rectangle {
                    id: nodeCircle
                    width: isSelected ? (index===0 || index===timelineList.model.count-1?app.fs*1.5:app.fs) : app.fs*0.75
                    height: width
                    radius: width / 2
                    //color: isSelected ? "#00adb5" : "#3a3a45"
                    color: 'transparent'
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    //anchors.verticalCenterOffset: -30
                    Behavior on width { NumberAnimation { duration: 200 } }
                    Behavior on color { ColorAnimation { duration: 200 } }
                    Rectangle{
                        width: parent.parent.width
                        height: app.fs*0.5
                        color: r.color
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.left
                        visible: index===0 && timelineList.currentIndex>0

                    }
                    Rectangle{
                        id: bg
                        color: apps.backgroundColor
                        radius: width/2
                        Rectangle{
                            width: parent.width*0.4
                            height: width
                            color: apps.fontColor
                            radius: width/2
                            anchors.centerIn: parent
                            visible: isSelected
                        }

                        anchors.fill: parent
                    }
                    Rectangle{
                        id: borde
                        color: 'transparent'
                        radius: width/2
                        border.color: apps.fontColor//isSelected ? "#eeeeee" : "#222831"
                        border.width: !isSelected ? 3 : 2
                        opacity: isSelected?1.0:0.5
                        anchors.fill: parent
                    }
                }

                // Información Detallada del Nodo
                Column{
                    id: xTop
                    anchors.bottom: nodeCircle.top
                    anchors.bottomMargin: app.fs*0.5
                    anchors.left: parent.left
                    anchors.right: parent.right
                    //anchors.margins: 6
                    spacing: app.fs*2
                }
                Column {
                    id: xBottom
                    anchors.top: nodeCircle.bottom
                    anchors.topMargin: app.fs*0.5
                    anchors.left: parent.left
                    anchors.right: parent.right
                    //anchors.margins: 6
                    spacing: app.fs*2

                    // 1. Fecha formateada (DD/MM/AAAA)
                    Text {
                        text: pad(model.day) + "/" + pad(model.month) + "\n" + model.year
                        //color: delegateItem.isSelected ? "#00adb5" : "#7f8c8d"
                        color: 'white'
                        font.bold: delegateItem.isSelected
                        //font.pointSize: 10
                        font.pixelSize: app.fs*0.5
                        horizontalAlignment: Text.AlignHCenter
                        width: parent.width
                        parent: !isSelected?xTop:xBottom
                        Rectangle{
                            width: parent.width
                            height: parent.height
                            color: 'red'
                            z: parent.z-1
                            visible: false
                        }
                    }




                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: timelineList.currentIndex = index
                }
            }
            Rectangle {
                id: line
                width: r.width*10//-r.wi*0.5-app.fs*2
                height: app.fs*0.1
                color: apps.fontColor
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: timelineList.currentIndex===0?app.fs*1.75+((line.width-r.width)/2):(timelineList.currentIndex===timelineList.model.count-1?0-(app.fs*2+((line.width-r.width)/2)):0)
                anchors.verticalCenter: parent.verticalCenter
                z: parent.z-1
            }
            ListModel {
                id: nodesModel
            }
        }

        Rectangle{
            id: xDatos
            width: r.width
            height: r.height-colGlobalCtx.height-timelineList.height-parent.spacing*3
            color: apps.backgroundColor
            border.width: 0
            border.color: 'blue'
            Column{
                id: colDatos
                spacing: app.fs*0.5
                anchors.centerIn: parent
                Text{
                    id: datoCtx
                    text: r.d1
                    width: r.width-app.fs*0.5
                    font.pixelSize: app.fs*0.5
                    color: apps.fontColor
                    wrapMode: Text.WordWrap
                }
                Text{
                    id: datoFecha
                    text: '<b>'+r.d2+'</b>'
                    width: r.width-app.fs*0.75
                    font.pixelSize: app.fs*0.5
                    color: apps.fontColor
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                }
                Rectangle{
                    width: parent.parent.width
                    //height: xDatos.height-app.fs
                    height: xDatos.height-datoCtx.contentHeight-datoFecha.contentHeight-(parent.spacing*2)
                    color: 'transparent'
                    border.width: 2
                    border.color: apps.fontColor
                    clip: true
                    Flickable{
                        id: flk
                        anchors.fill: parent
                        contentWidth: width
                        contentHeight: datoDes.contentHeight+app.fs*10
                        TextArea{
                            id: datoDes
                            text: r.d3.replace(/\. /g, '\n\n')
                            width: r.width-app.fs*0.5
                            font.pixelSize: app.fs*0.5
                            color: apps.fontColor
                            wrapMode: Text.WordWrap

                        }
                    }
                }
            }
        }

    }


    function next() {
        if (timelineList.currentIndex < timelineList.count - 1) {
            timelineList.currentIndex++;
        }
    }

    function back() {
        if (timelineList.currentIndex > 0) {
            timelineList.currentIndex--;
        }
    }

    // Función para cargar el JSON con el nuevo esquema extendido
    function loadData(jsonString) {
        nodesModel.clear();
        try {
            var j= JSON.parse(jsonString);
            var dataData = j.eventos;
            r.d0=j.title
            r.d00=j.description
            for (var i = 0; i < dataData.length; i++) {
                var d = dataData[i];
                nodesModel.append({
                                      "title": d.title || "",
                                      "description": d.description || "",
                                      // Nuevos campos de tiempo detallados
                                      "day": d.day !== undefined ? d.day : 1,
                                      "month": d.month !== undefined ? d.month : 1,
                                      "year": d.year !== undefined ? d.year : 2000,
                                      "hour": d.hour !== undefined ? d.hour : 0,
                                      "minute": d.minute !== undefined ? d.minute : 0,
                                      "gmt": d.gmt !== undefined ? d.gmt : 0.0,
                                      // Nuevos campos geográficos/espacio
                                      "place": d.place,
                                      "lat": d.lat !== undefined ? d.lat : 0.0,
                                      "lon": d.lon !== undefined ? d.lon : 0.0,
                                      "alt": d.alt !== undefined ? d.alt : 0.0
                                  });
            }
            if (nodesModel.count > 0) {
                timelineList.currentIndex = 0;
            }
        } catch(e) {
            console.error("Error al parsear el JSON en TimeLineView:", e);
        }
    }
    // Función auxiliar interna para rellenar ceros a la izquierda (ej: 05 en vez de 5)
    function pad(n) {
        return n < 10 ? "0" + n : n;
    }
}
