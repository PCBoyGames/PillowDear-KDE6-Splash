import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: root
    color: "black"
    anchors.fill: parent

    property int stage

    onStageChanged: {
        if (stage == 1) {
            introAnimation.running = true
        }
    }

    Image {
        id: gradient
        anchors.fill: parent
        source: "images/gradient.png"
    }

    Item {
        id: skyScene
        anchors.fill: parent
        ListModel {
            id: cloudModel
            ListElement { sprite: "images/cloud1.png" }
            ListElement { sprite: "images/cloud2.png" }
            ListElement { sprite: "images/cloud3.png" }
            ListElement { sprite: "images/cloud4.png" }
            ListElement { sprite: "images/cloud5.png" }
            ListElement { sprite: "images/cloud6.png" }
            ListElement { sprite: "images/cloud7.png" }
            ListElement { sprite: "images/cloud8.png" }
            ListElement { sprite: "images/cloud9.png" }
            ListElement { sprite: "images/cloud1.png" }
            ListElement { sprite: "images/cloud2.png" }
            ListElement { sprite: "images/cloud3.png" }
            ListElement { sprite: "images/cloud4.png" }
            ListElement { sprite: "images/cloud5.png" }
            ListElement { sprite: "images/cloud6.png" }
            ListElement { sprite: "images/cloud7.png" }
            ListElement { sprite: "images/cloud8.png" }
            ListElement { sprite: "images/cloud9.png" }
        }
        Repeater {
            model: cloudModel
            delegate: Image {
                id: cloud
                source: model.sprite
                fillMode: Image.PreserveAspectFit
                readonly property double localScale: Math.random() * 0.5 + 0.5
                readonly property int baseDuration: Math.random() * 40000 + 100000
                scale: localScale
                width: 150 * localScale
                SequentialAnimation {
                    id: masterCloudAnimation
                    XAnimator {
                        id: initialRun
                        target: cloud
                        to: -cloud.width
                    }
                    XAnimator {
                        id: infiniteLoop
                        target: cloud
                        from: skyScene.width > 0 ? skyScene.width : 800
                        to: -cloud.width
                        duration: cloud.baseDuration
                        loops: Animation.Infinite
                    }
                }
                Connections {
                    target: skyScene
                    function onWidthChanged() {
                        if (skyScene.width > 0 && !masterCloudAnimation.running) {
                            cloud.y = Math.random() * (skyScene.height - cloud.height * localScale)
                            var randomX = Math.random() * skyScene.width * 1.5
                            cloud.x = randomX
                            var distanceRemaining = randomX + cloud.width
                            var totalDistance = skyScene.width + cloud.width
                            initialRun.duration = (distanceRemaining / totalDistance) * cloud.baseDuration
                            masterCloudAnimation.start()
                        }
                    }
                }
            }
        }
    }


    Image {
        id: grass
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        source: "images/grass.png"
        fillMode: Image.PreserveAspectCrop
        sourceSize.width: parent.width
        property real riseOffset: height
        transform: Translate {
            y: grass.riseOffset
        }
        SequentialAnimation {
            id: grassRise
            running: true
            PauseAnimation {
                duration: 200
            }
            NumberAnimation {
                target: grass
                property: "riseOffset"
                to: 0
                duration: 500
                easing.type: Easing.OutQuad
            }
        }
    }

    Image {
        id: sun
        anchors.left: parent.left
        anchors.top: parent.top
        source: "images/sun.png"
        sourceSize.height: parent.height / 2.4
        property int rotate: -5
        transform: Rotation {
            angle: sun.rotate
            origin.x: sun.width / 2
            origin.y: sun.height / 2
        }
        SequentialAnimation {
            id: sunLoop
            running: true
            loops: Animation.Infinite
            PauseAnimation {
                duration: 369
            }
            NumberAnimation {
                target: sun
                property: "rotate"
                to: 5
                from: -5
                duration: 0
            }
            PauseAnimation {
                duration: 369
            }
            NumberAnimation {
                target: sun
                property: "rotate"
                to: -5
                from: 5
                duration: 0
            }
        }
    }

    Image {
        id: pillow
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        source: "images/pillow.png"
        sourceSize.height: parent.height / 2
        property real riseOffset: height
        property real runOffset: -width
        transform: Translate {
            x: pillow.runOffset
            y: pillow.riseOffset
        }
        SequentialAnimation {
            id: goodMorningPil
            running: true
            PauseAnimation {
                duration: 1500
            }
            ParallelAnimation {
                NumberAnimation {
                    target: pillow
                    property: "riseOffset"
                    to: 0
                    duration: 500
                    easing.type: Easing.OutQuad
                }
                NumberAnimation {
                    target: pillow
                    property: "runOffset"
                    to: 0
                    duration: 500
                    easing.type: Easing.OutQuad
                }
            }
        }
    }

    Item {
        id: content
        anchors.fill: parent
        opacity: 0

        Image {
            id: logo
            anchors.horizontalCenter: parent.horizontalCenter
            source: "images/logo.png"
            sourceSize.width: parent.width / 2
            sourceSize.height: parent.height / 2
            y: (parent.height - height) / 2 - 10
            property real bobOffset: 0
            transform: Translate {
                y: logo.bobOffset
            }
            ScaleAnimator {
                id: introScale
                target: logo
                from: 0.5
                to: 1
                duration: 500
                easing.type: Easing.OutQuad
                running: true
                onFinished: bobLoop.start()
            }
            SequentialAnimation {
                id: bobLoop
                loops: Animation.Infinite
                NumberAnimation {
                    target: logo
                    property: "bobOffset"
                    from: 0
                    to: 20
                    duration: 1500
                    easing.type: Easing.InOutQuad
                }
                NumberAnimation {
                    target: logo
                    property: "bobOffset"
                    from: 20
                    to: 0
                    duration: 1500
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }

    OpacityAnimator {
        id: introAnimation
        target: content
        from: 0
        to: 1
        duration: 1000
        easing.type: Easing.OutQuad
    }
}
