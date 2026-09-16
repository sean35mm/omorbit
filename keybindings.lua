-- Optional: manually append this block to ~/.config/hypr/bindings.lua.
-- Do not source this repository file; plugin removal would leave a broken path.
-- BEGIN Workspace Picker keybindings

-- Named workspaces A-Z. Moving follows the window, matching numeric workspaces.
local workspace_letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

for index = 1, #workspace_letters do
  local letter = workspace_letters:sub(index, index)
  hl.unbind("SUPER + ALT + " .. letter)
  -- Stock bindings use both modifier orderings, and unbind matches that spelling.
  hl.unbind("SUPER + ALT + SHIFT + " .. letter)
  hl.unbind("SUPER + SHIFT + ALT + " .. letter)
end

for index = 1, #workspace_letters do
  local letter = workspace_letters:sub(index, index)
  local workspace = "name:" .. letter
  o.bind("SUPER + ALT + " .. letter, "Switch to workspace " .. letter, hl.dsp.focus({ workspace = workspace }))
  o.bind("SUPER + ALT + SHIFT + " .. letter, "Move window to workspace " .. letter, hl.dsp.window.move({ workspace = workspace }))
end

-- END Workspace Picker keybindings
