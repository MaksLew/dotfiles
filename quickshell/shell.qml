import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.Pipewire
import Quickshell.Services.UPower

ShellRoot {
    id: root

    readonly property color base: "#1e1e2e"
    readonly property color text: "#cdd6f4"
    readonly property color surface2: "#585b70"
    readonly property color overlay1: "#7f849c"
    readonly property color blue: "#89b4fa"
    readonly property color sapphire: "#74c7ec"
    readonly property color teal: "#94e2d5"
    readonly property color green: "#a6e3a1"
    readonly property color yellow: "#f9e2af"
    readonly property color peach: "#fab387"
    readonly property color red: "#f38ba8"
    readonly property color mauve: "#cba6f7"
    readonly property color pink: "#f5c2e7"

    property string cpu: "--"
    property string memory: "--"
    property string temperature: "--"
    property string network: "No connection "
    property string bluetooth: ""
    property string weather: "--"
    property bool alternateClock: false

    function run(command) { Quickshell.execDetached(["sh", "-c", command]); }

    component BarText: Text {
        property color accent: root.text
        color: accent
        font.family: "BlexMono Nerd Font Mono Medium"
        font.pixelSize: 14
        height: parent.height
        verticalAlignment: Text.AlignVCenter
        leftPadding: 3
        rightPadding: 3
    }

    component Separator: BarText {
        text: "|"
        accent: root.surface2
        leftPadding: 1
        rightPadding: 1
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    Process {
        id: statusProcess
        command: [Quickshell.shellDir + "/status.sh"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const values = {};
                for (const line of text.trim().split("\n")) {
                    const split = line.indexOf("=");
                    if (split > 0) values[line.slice(0, split)] = line.slice(split + 1);
                }
                root.cpu = values.cpu || "--";
                root.memory = values.memory || "--";
                root.temperature = values.temperature || "--";
                root.network = values.network || "No connection ";
            }
        }
    }

    Process {
        id: bluetoothProcess
        command: [Quickshell.shellDir + "/bluetooth.sh"]
        running: true
        stdout: StdioCollector { onStreamFinished: root.bluetooth = text.trim() }
    }

    Process {
        id: weatherProcess
        command: [Quickshell.shellDir + "/weather.sh"]
        running: true
        stdout: StdioCollector { onStreamFinished: root.weather = text.trim() || "--" }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: {
            if (!statusProcess.running) statusProcess.running = true;
            if (!bluetoothProcess.running) bluetoothProcess.running = true;
        }
    }

    Timer {
        interval: 900000
        running: true
        repeat: true
        onTriggered: if (!weatherProcess.running) weatherProcess.running = true
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar
            required property var modelData
            screen: modelData
            color: root.base
            implicitHeight: 30
            anchors { top: true; left: true; right: true }

            Row {
                id: left
                anchors { left: parent.left; top: parent.top; bottom: parent.bottom; leftMargin: 2 }
                spacing: 6

                Item {
                    id: workspaceBox
                    width: workspaceRow.width
                    height: parent.height

                    readonly property var activeWorkspace: {
                        const monitor = Hyprland.monitorFor(bar.screen);
                        return monitor ? monitor.activeWorkspace : null;
                    }
                    readonly property real activeX: {
                        for (let i = 0; i < workspaceRepeater.count; i++) {
                            const item = workspaceRepeater.itemAt(i);
                            if (item && item.visible && item.modelData === activeWorkspace) return item.x;
                        }
                        return 0;
                    }

                    Row {
                        id: workspaceRow
                        height: parent.height
                        spacing: 0

                    Repeater {
                        id: workspaceRepeater
                        model: Hyprland.workspaces
                        delegate: Item {
                            id: workspace
                            required property var modelData
                            visible: modelData.id > 0 && modelData.monitor && modelData.monitor.name === bar.screen.name
                            width: visible ? 20 : 0
                            height: parent.height

                            BarText {
                                anchors.fill: parent
                                text: workspace.modelData.name
                                accent: workspace.modelData.urgent ? root.peach : (workspace.modelData.toplevels.values.length ? root.mauve : root.overlay1)
                                opacity: workspace.modelData.active ? 1 : 0.75
                                horizontalAlignment: Text.AlignHCenter
                                leftPadding: 0
                                rightPadding: 0
                            }
                            Rectangle {
                                visible: workspace.modelData.urgent
                                anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
                                height: 2
                                color: root.peach
                            }
                            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: workspace.modelData.activate() }
                        }
                    }
                    }

                    Rectangle {
                        visible: workspaceBox.activeWorkspace !== null
                        x: workspaceBox.activeX
                        anchors.bottom: parent.bottom
                        width: 20
                        height: 2
                        color: root.mauve
                        Behavior on x { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
                    }
                }

                Separator {}
                BarText {
                    text: " " + root.cpu + "%"
                    accent: root.peach
                    MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: root.run("ghostty -e btm") }
                }
                Separator {}
                BarText {
                    text: " " + root.memory + "GiB"
                    accent: "#ffffff"
                    MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: root.run("ghostty -e btm") }
                }
                Separator {}
                BarText {
                    text: " " + root.temperature + "°C"
                    accent: Number(root.temperature) >= 80 ? root.red : root.pink
                }
                Separator {}
            }

            Row {
                anchors { horizontalCenter: parent.horizontalCenter; top: parent.top; bottom: parent.bottom }
                spacing: 6

                BarText {
                    text: " " + Qt.formatDateTime(clock.date, root.alternateClock ? "yyyy-MM-dd HH:mm" : "dddd, dd MMMM HH:mm")
                    accent: root.yellow
                    MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: root.alternateClock = !root.alternateClock }
                }
                Separator {}
                BarText { text: root.weather; accent: "#ffffff" }
            }

            Row {
                anchors { right: parent.right; top: parent.top; bottom: parent.bottom; rightMargin: 2 }
                spacing: 6

                Separator {}
                BarText {
                    readonly property var battery: UPower.displayDevice
                    readonly property int percent: battery ? Math.round(battery.percentage * 100) : 0
                    readonly property bool charging: battery && battery.state === UPowerDeviceState.Charging
                    visible: battery && battery.isPresent
                    text: (charging ? "" : ["", "", "", "", ""][Math.min(4, Math.floor(percent / 20))]) + " " + percent + "%"
                    accent: !charging && percent <= 15 ? root.red : (!charging && percent <= 30 ? root.yellow : root.green)
                }
                Separator { visible: root.bluetooth !== "" }
                BarText {
                    visible: root.bluetooth !== ""
                    text: root.bluetooth
                    accent: root.sapphire
                    MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: root.run(Quickshell.shellDir + "/bluetooth-manager.sh") }
                }
                Separator {}
                BarText {
                    readonly property var sink: Pipewire.defaultAudioSink
                    readonly property var audio: sink ? sink.audio : null
                    readonly property int volume: audio ? Math.round(audio.volume * 100) : 0
                    text: audio && audio.muted ? "Muted" : (volume < 34 ? " " : (volume < 67 ? " " : " ")) + volume + "%"
                    accent: audio && audio.muted ? root.red : root.blue
                    MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: root.run("pavucontrol") }
                }
                Separator {}
                BarText {
                    text: root.network
                    accent: root.network === "No connection " ? root.yellow : root.mauve
                    MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: root.run(Quickshell.shellDir + "/network-manager.sh") }
                }
            }
        }
    }
}
