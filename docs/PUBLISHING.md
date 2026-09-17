# Publishing Omorbit

Marketplace submission is a separate, manual step. The repository is prepared for a public GitHub release at:

`https://github.com/sean35mm/omorbit`

The stable plugin ID is `io.github.sean35mm.omorbit`. The root contains the standalone manifest, README, license, QML entry point, and safe install/removal instructions; clone-only `omarchy.clonedFrom` metadata is intentionally absent.

## Before publishing

- [ ] Rename the public GitHub repository to `omorbit` and review the exact files to publish.
- [ ] Install from the public URL with `omarchy plugin add ... --enable` and complete the interactive trust prompt.
- [ ] Confirm the widget appears alongside the stock widget by default.
- [ ] Test click open/close, scrolling, current marker, numeric rows, letter rows, empty rows, app names, and workspace switching.
- [ ] Test `omarchy-shell shell summon io.github.sean35mm.omorbit '{}'` and `omarchy-shell shell hide io.github.sean35mm.omorbit`.
- [ ] Disable and re-enable the plugin, including placement in the left section.
- [ ] Restart the shell and confirm the plugin still loads.
- [ ] Remove the plugin and confirm that stock-widget and optional-keybinding restoration behave exactly as documented.
- [ ] Repeat `omarchy plugin validate`, `qmllint`, `luac -p`, and JSON parsing checks on the final public checkout.
- [ ] Review the repository for private information before making it public.

These runtime checks remain unchecked until they are performed against the standalone installed package; prior testing of a local clone is not a substitute.

## Suggested marketplace listing

These are suggestions, not submitted metadata:

- **Title:** Omorbit
- **Summary:** AeroSpace-inspired Omarchy bar picker for numeric and named Hyprland workspaces, with current-workspace and application indicators.
- **Category:** Compositor
- **Tags:** `workspaces`, `hyprland`, `bar-widget`, `productivity`, `aerospace-inspired`
- **Code repository:** https://github.com/sean35mm/omorbit

Submit only after the public repository and manual checks are complete:

- Submission form: https://github.com/omacom/omarchy-plugin-marketplace/issues/new?template=submit-plugin.yml
- Development guide: https://omarchyplugins.com/develop.html
- Publishing guide: https://omarchyplugins.com/publish.html

## Preview guidance

A preview is optional and the marketplace optimizes it automatically. Do not add a fake or placeholder image and do not add a README image link before the asset exists.

For a useful hero image, open the dropdown and take a tightly cropped screenshot showing the current marker, several numeric and letter rows, and application names. An optional second image can show the compact closed indicator; a short demo is also optional. Hide private windows and notification content first. The widget displays application names rather than window titles, but review the result before publishing.

If available, use `omarchy capture screenshot region`: open the picker, invoke the command, and select the region. If invoking the region selector dismisses the popup, use a familiar capture workflow with a delay rather than guessing unsupported flags. Save the final hero image as `assets/preview.png` if one is created.
