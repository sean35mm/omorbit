import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "io.github.sean35mm.omorbit"

  property bool popupOpen: false
  readonly property bool opened: popupOpen

  readonly property var destinations: {
    var result = []
    for (var number = 1; number <= 10; number++) {
      result.push({ label: number === 10 ? "0" : String(number), kind: "numeric", id: number, selector: String(number) })
    }
    for (var code = 65; code <= 90; code++) {
      var letter = String.fromCharCode(code)
      result.push({ label: letter, kind: "named", name: letter, selector: "name:" + letter })
    }
    return result
  }

  function open() { popupOpen = true }
  function close() { popupOpen = false }
  function toggle() { popupOpen = !popupOpen }

  function workspaceFor(destination) {
    var values = Hyprland.workspaces.values || []
    for (var i = 0; i < values.length; i++) {
      var workspace = values[i]
      if (destination.kind === "numeric" && workspace.id === destination.id) return workspace
      if (destination.kind === "named" && workspace.name === destination.name) return workspace
    }
    return null
  }

  function destinationFor(workspace) {
    if (!workspace) return null
    for (var i = 0; i < destinations.length; i++) {
      if (workspaceFor(destinations[i]) === workspace) return destinations[i]
    }
    return null
  }

  function normalizeAppId(id) {
    return String(id || "").trim().replace(/\.desktop$/i, "").toLowerCase()
  }

  function desktopEntryName(appId) {
    var normalized = normalizeAppId(appId)
    if (!normalized) return ""

    var entries = DesktopEntries.applications.values || []
    for (var i = 0; i < entries.length; i++) {
      if (normalizeAppId(entries[i].id) === normalized) return String(entries[i].name || entries[i].id || appId)
    }
    return String(appId).replace(/\.desktop$/i, "")
  }

  function appNames(workspace) {
    if (!workspace) return []

    var names = []
    var seen = ({})
    var toplevels = workspace.toplevels.values || []
    for (var i = 0; i < toplevels.length; i++) {
      var toplevel = toplevels[i]
      var appId = toplevel.wayland ? toplevel.wayland.appId : ""
      if (!appId && toplevel.lastIpcObject) appId = toplevel.lastIpcObject.class || ""
      var name = desktopEntryName(appId).trim()
      var key = name.toLowerCase()
      if (name && !seen[key]) {
        seen[key] = true
        names.push(name)
      }
    }

    names.sort(function(left, right) { return left.localeCompare(right) })
    return names
  }

  function focusDestination(destination) {
    if (!root.bar) return
    root.bar.run("hyprctl dispatch " + Util.shellQuote("hl.dsp.focus({ workspace = \"" + destination.selector + "\" })"))
    root.close()
  }

  readonly property var focusedDestination: destinationFor(Hyprland.focusedWorkspace)
  readonly property string focusedLabel: {
    if (focusedDestination) return focusedDestination.label
    var workspace = Hyprland.focusedWorkspace
    if (!workspace) return "—"
    return String(workspace.name || workspace.id || "—")
  }
  readonly property real trailingGap: root.vertical ? 0 : Style.spaceReal(1.5)

  implicitWidth: indicator.implicitWidth + trailingGap
  implicitHeight: indicator.implicitHeight

  WidgetButton {
    id: indicator
    anchors.left: parent.left
    bar: root.bar
    text: root.focusedLabel
    horizontalMargin: 8
    verticalPadding: 6
    fixedWidth: root.vertical ? root.barSize : Style.space(30)
    fixedHeight: root.barSize
    onPressed: function() { root.toggle() }
  }

  PopupCard {
    id: popup
    anchorItem: indicator
    owner: root
    bar: root.bar
    open: root.popupOpen
    contentWidth: popup.fittedContentWidth(Style.space(320))
    contentHeight: popup.fittedContentHeight(destinationColumn.implicitHeight, Style.space(480))

    Flickable {
      id: destinationFlick
      anchors.fill: parent
      contentWidth: width
      contentHeight: destinationColumn.implicitHeight
      clip: true
      boundsBehavior: Flickable.StopAtBounds
      flickableDirection: Flickable.VerticalFlick
      interactive: contentHeight > height

      ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

      Column {
        id: destinationColumn
        width: destinationFlick.width
        spacing: 0

        Repeater {
          model: root.destinations

          delegate: Item {
            id: destinationRow
            required property var modelData

            readonly property var workspace: root.workspaceFor(modelData)
            readonly property bool focused: workspace !== null && workspace.focused
            readonly property var apps: root.appNames(workspace)

            width: destinationColumn.width
            implicitHeight: Style.space(30)

            Rectangle {
              anchors.fill: parent
              radius: Math.max(2, Style.cornerRadius)
              color: destinationRow.focused
                ? Style.normalFillFor(root.bar.foreground, Color.accent)
                : (rowMouse.containsMouse ? Style.hoverFillFor(root.bar.foreground, root.bar.foreground) : "transparent")
            }

            Text {
              anchors.left: parent.left
              anchors.leftMargin: Style.space(8)
              anchors.verticalCenter: parent.verticalCenter
              width: Style.space(16)
              text: destinationRow.focused ? "✓" : ""
              color: root.bar.foreground
              font.family: root.bar.fontFamily
              font.pixelSize: Style.font.bodySmall
              horizontalAlignment: Text.AlignHCenter
            }

            Text {
              anchors.left: parent.left
              anchors.leftMargin: Style.space(32)
              anchors.verticalCenter: parent.verticalCenter
              width: Style.space(24)
              text: destinationRow.modelData.label
              color: root.bar.foreground
              font.family: root.bar.fontFamily
              font.pixelSize: Style.font.body
              font.bold: destinationRow.focused
              horizontalAlignment: Text.AlignHCenter
            }

            Text {
              textFormat: Text.PlainText
              anchors.left: parent.left
              anchors.leftMargin: Style.space(66)
              anchors.right: parent.right
              anchors.rightMargin: Style.space(12)
              anchors.verticalCenter: parent.verticalCenter
              text: destinationRow.apps.join(", ")
              color: Qt.darker(root.bar.foreground, 1.25)
              font.family: root.bar.fontFamily
              font.pixelSize: Style.font.bodySmall
              elide: Text.ElideRight
            }

            MouseArea {
              id: rowMouse
              anchors.fill: parent
              hoverEnabled: true
              cursorShape: Qt.PointingHandCursor
              onClicked: root.focusDestination(destinationRow.modelData)
            }
          }
        }
      }
    }
  }
}
