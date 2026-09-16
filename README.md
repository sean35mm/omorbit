# Workspace Picker

An AeroSpace-inspired workspace picker for the Omarchy bar. It keeps a compact current-workspace indicator and opens a scrollable list of 36 fixed destinations: numeric workspaces `1`–`9` and `0`, followed by named workspaces `A`–`Z`.

## Features

- Shows the current workspace in the bar.
- Lists every numeric and named destination, including empty workspaces.
- Shows distinct application names on occupied workspaces, never window titles.
- Marks the current workspace and switches to a row when clicked.
- Uses Omarchy's current Hyprland Lua dispatch path; it is not a Waybar module or an individual-window selector.
- Does not install or override keyboard shortcuts automatically.

## Requirements

- Omarchy with the Quattro shell plugin system.
- Hyprland with Omarchy's Lua dispatch helpers.

Tested with Omarchy `4.0.3-1` and Hyprland `0.56.2-2`. Check your installed versions with:

```sh
omarchy version
pacman -Q hyprland
```

## Install

Review the repository, then run the interactive installer:

```sh
omarchy plugin add https://github.com/sean35mm/omarchy-workspace-picker.git --enable
```

This adds a standalone widget and prompts for placement, with the left section as the default. It does not replace the stock workspace widget. To use it as a replacement, disable the stock widget after installation:

```sh
omarchy plugin disable omarchy.workspaces
```

If another custom workspace widget is active, disable that widget by its own plugin ID instead.

## Use and test

Click the workspace indicator to open or close the picker. Click any row to switch to that workspace. The shell lifecycle can also be tested directly:

```sh
omarchy-shell shell summon io.github.sean35mm.workspace-picker '{}'
omarchy-shell shell hide io.github.sean35mm.workspace-picker
```

Plugin files normally hot-reload. If discovery becomes stale, run `omarchy-shell shell rescanPlugins`; only if that is insufficient, run `omarchy restart shell`.

## Optional A–Z keyboard shortcuts

The widget works without custom shortcuts. To add named workspace shortcuts, manually copy the complete block from the `BEGIN` marker through the `END` marker in [`keybindings.lua`](keybindings.lua) and append it to `~/.config/hypr/bindings.lua`. Do not overwrite that file and do not source `keybindings.lua` from the repository: removing the plugin would then leave a startup-time reference to a deleted path.

The block makes every `SUPER + ALT + letter` chord switch to named workspace `A`–`Z`; adding `SHIFT` moves the focused window there and follows it. Numeric Omarchy shortcuts `SUPER + 1`–`9`/`0`, plain `SUPER + letter` shortcuts, and `SUPER + SHIFT` application launchers are untouched.

These 11 default chords are intentionally replaced by the optional block on the tested Omarchy version:

| Chord | Existing default action replaced |
| --- | --- |
| `SUPER + ALT + F` | Full width |
| `SUPER + ALT + G` | Remove window from group |
| `SUPER + ALT + K` | Tmux keybindings |
| `SUPER + ALT + S` | Move to scratchpad |
| `SUPER + ALT + SHIFT + A` | Grok |
| `SUPER + ALT + SHIFT + B` | Private browser |
| `SUPER + ALT + SHIFT + E` | New email |
| `SUPER + ALT + SHIFT + F` | File manager in current directory |
| `SUPER + ALT + SHIFT + G` | WhatsApp |
| `SUPER + ALT + SHIFT + M` | Music TUI |
| `SUPER + ALT + SHIFT + X` | New X post |

Defaults can vary between Omarchy releases. Inspect the current menu before opting in:

```sh
omarchy menu keybindings --print
```

After appending or removing the marked block, validate the live Hyprland configuration:

```sh
hyprctl reload
hyprctl configerrors
```

Removing the marked block and reloading restores the active Omarchy defaults; plugin disable or removal does not edit or restore manually added bindings.

## Remove

First remove only the marked Workspace Picker block from `~/.config/hypr/bindings.lua` if you added it, then run `hyprctl reload` and `hyprctl configerrors`. Remove the plugin interactively:

```sh
omarchy plugin remove io.github.sean35mm.workspace-picker
```

If you disabled the stock widget, restore it explicitly:

```sh
omarchy plugin enable omarchy.workspaces --section left
```

Disabling or removing this standalone plugin does not automatically restore the stock widget or revert manual keybindings. None of these commands removes user applications.

## License

[MIT](LICENSE)
