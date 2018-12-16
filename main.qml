import QtQuick 2.9
import QtQuick.Window 2.2
import QtCharts 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.11

Item {
    width: 1400
    height: 600

    GridLayout {
        GroupBox {
            title: "Functions"
            ColumnLayout {
                ExclusiveGroup { id: tabPositionGroup }
                RadioButton {
                    id: sin
                    text: "sin(x)"
                    checked: true
                    exclusiveGroup: tabPositionGroup
                }
                RadioButton {
                    id: cos
                    text: "cos(x)"
                    exclusiveGroup: tabPositionGroup
                }
            }
        }

        ChartView {
            id: chart
            title: "Graph"
            antialiasing: true
            height: 600
            width: 600
            axes: [
                 ValueAxis{
                     id: xAxis
                     min: -10.0
                     max: 10.0
                 },
                 ValueAxis{
                     id: yAxis
                     min: -10.0
                     max: 10.0
                 }
            ]
        }


        RowLayout {
            id: row
            anchors.top: parent.top
            height: 50

            property int counter: 0
            Button {
                id: button1
                text: qsTr("Add X")
                width: (row.width / 5)*2
                height: 50

                onClicked: {
                    if (xCoordinate.text) {
                        var digit = Number(xCoordinate.text.replace(",","."));

                        listModel.append({idshnik: digit, value: sin.checked ? Math.sin(digit) : Math.cos(digit)})
                        row.counter++
                    }
                }
            }

            Button {
                id: button2
                text: qsTr("Create plot")
                width: (row.width / 5)*2
                height: 50

                onClicked: {
                    var series = chart.createSeries(ChartView.SeriesTypeLine, "Lagr", xAxis, yAxis);
                    var scatter = chart.createSeries(ChartView.SeriesTypeScatter, "dots", xAxis, yAxis);
                    var idealSeries = chart.createSeries(ChartView.SeriesTypeLine, "ideal", xAxis, yAxis);
                    for (var l = -10; l < 10 ; l+=0.2) {
                        idealSeries.append(l, sin.checked ? Math.sin(l) : Math.cos(l));
                    }

                    var Xs = []
                    for(var i = 0; i < row.counter; i++)
                    {
                        Xs.push([listModel.get(i).idshnik, listModel.get(i).value]);
                        scatter.append(Xs[i][0], Xs[i][1]);
                    }

                    function lol(a, b) {
                        return a[0] - b[0];
                    }

                    Xs.sort(lol);
                    function lagranz(Xs, t){
                        var z = 0.0;
                        for (var j=0; j < Xs.length; j++){
                            var p1=1.0;
                            var p2=1.0;
                            for (var i=0; i < Xs.length; i++){
                                if (i != j){
                                    p1=p1*(t-Xs[i][0]);
                                    p2=p2*(Xs[j][0] - Xs[i][0]);
                                }
                            }
                            z = z+Xs[j][1]*p1/p2;
                        }
                        return z;
                    }

                    for (l = -10; l < 10 ; l+=0.2) {
                        series.append(l, lagranz(Xs, l));
                    }
                }
            }
        }

        RowLayout {
            anchors.top: parent.top
            Button {
                text: "Вычислить Y интерпол."
                onClicked: {
                    var Xs = []
                    for(var i = 0; i < row.counter; i++)
                    {
                        Xs.push([listModel.get(i).idshnik, listModel.get(i).value]);
                    }

                    function lol(a, b) {
                        return a[0] - b[0];
                    }

                    Xs.sort(lol);
                    function lagranz(Xs, t){
                        var z = 0.0;
                        for (var j=0; j < Xs.length; j++){
                            var p1=1.0;
                            var p2=1.0;
                            for (var i=0; i < Xs.length; i++){
                                if (i != j){
                                    p1=p1*(t-Xs[i][0]);
                                    p2=p2*(Xs[j][0] - Xs[i][0]);
                                }
                            }
                            z = z+Xs[j][1]*p1/p2;
                        }
                        return z;
                    }

                    addTask.thisIsText = lagranz(Xs, xCoordinate.text.replace(",", "."));

                }
            }

            Label {
                id: addTask
                width: parent.width / 2
                anchors.margins: 5

                property string thisIsText: "Сначала График"
                text: thisIsText
            }
        }

        TextInput {
            id: xCoordinate

            anchors.margins: 5
            anchors.top: row.bottom
            anchors.left: row.left
            anchors.right: row.right

            maximumLength: 5
            validator: DoubleValidator {}

            property string placeholderText: "Enter X here..."
            Text {
                text: xCoordinate.placeholderText
                color: "#aaa"
                visible: !xCoordinate.text && !xCoordinate.activeFocus
            }
        }

        // ListView to represent the data as a list
        ListView {
            id: listView1

            anchors.top: xCoordinate.bottom
            anchors.bottom: parent.bottom
            anchors.left: row.left
            anchors.right: row.right

            delegate: Item {
                id: item
                anchors.left: parent.left
                anchors.right: parent.right
                height: 40

                RowLayout {
                    anchors.fill: parent
                    Label {
                        width: parent.width / 2
                        anchors.margins: 5

                        text: idshnik
                    }
                    TextInput {
                        width: parent.width / 2
                        horizontalAlignment: Text.AlignLeft
                        text: value
                        onTextChanged: value = Number(this.text)

                    }
                }

            }

            model: ListModel {
                id: listModel
            }
        }
    }
}
