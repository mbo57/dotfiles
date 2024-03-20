local wezterm = require 'wezterm'
local config = wezterm.config_builder()

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  config.default_domain = 'WSL:Ubuntu'
end

-- config.color_scheme = "Afterglow"
-- config.color_scheme = "Ashes (dark) (terminal.sexy)"
-- config.color_scheme = "astromouse (terminal.sexy)"
-- config.color_scheme = "Atelier Dune (base16)"
-- config.color_scheme = "Ayu Mirage"
-- config.color_scheme = "Bamboo"
config.color_scheme = "Catppuccin Macchiato"
-- config.color_scheme = "Catppuccin Mocha"
-- config.color_scheme = "Chalk (Gogh)"
-- config.color_scheme = "nord"
-- config.color_scheme = "catppuccin-frappe"

wezterm.on('toggle_opacity', function(window)
    local overrides = window:get_config_overrides() or {}
    if overrides.window_background_opacity == 1 then
        overrides.window_background_opacity = 0.1
    else
        overrides.window_background_opacity = 1
    end
    window:set_config_overrides(overrides)
end)

local act = wezterm.action
config.leader = { key = ';', mods = 'CTRL', timeout_milliseconds = 2000 }
config.keys = {
    { key = 'f',   mods = 'LEADER',       action = act.ToggleFullScreen },
    { key = 'd',   mods = 'LEADER',       action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = 'd',   mods = 'LEADER|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
    { key = 'q',   mods = 'LEADER',       action = act.CloseCurrentPane { confirm = true } },
    { key = 'o',   mods = 'LEADER',       action = wezterm.action.EmitEvent 'toggle_opacity' },
    { key = 'v',   mods = 'LEADER',       action = act.PasteFrom 'Clipboard' },
    { key = 'c',   mods = 'LEADER',       action = act.ActivateCopyMode },
    { key = 'n',   mods = 'LEADER',       action = act.SpawnCommandInNewWindow },
    { key = 'p',   mods = 'LEADER',       action = act.ActivateCommandPalette },
    { key = 'h',   mods = 'LEADER',       action = act.ActivatePaneDirection 'Left' },
    { key = 'j',   mods = 'LEADER',       action = act.ActivatePaneDirection 'Down' },
    { key = 'k',   mods = 'LEADER',       action = act.ActivatePaneDirection 'Up' },
    { key = 'l',   mods = 'LEADER',       action = act.ActivatePaneDirection 'Right' },
    { key = 'H',   mods = 'LEADER|SHIFT', action = act.AdjustPaneSize { 'Left', 5 } },
    { key = 'J',   mods = 'LEADER|SHIFT', action = act.AdjustPaneSize { 'Down', 5 } },
    { key = 'K',   mods = 'LEADER|SHIFT', action = act.AdjustPaneSize { 'Up', 5 } },
    { key = 'L',   mods = 'LEADER|SHIFT', action = act.AdjustPaneSize { 'Right', 5 } },
    { key = '=',   mods = 'CTRL',         action = act.IncreaseFontSize },
    { key = '-',   mods = 'CTRL',         action = act.DecreaseFontSize },
    { key = 't',   mods = 'LEADER',       action = act.SpawnTab 'CurrentPaneDomain' },
    { key = 'l',   mods = 'LEADER|CTRL',  action = act.ActivateTabRelative(1) },
    { key = 'h',   mods = 'LEADER|CTRL',  action = act.ActivateTabRelative(-1) },
    { key = 'Tab', mods = 'LEADER',       action = act.ActivateTabRelative(1) },
    { key = 'Tab', mods = 'LEADER|CTRL',  action = act.ActivateTabRelative(-1) },
}
config.mouse_bindings = {
	{
		event = { Down = { streak = 1, button = "Right" } },
		mods = "NONE",
		action = wezterm.action_callback(function(window, pane)
			local has_selection = window:get_selection_text_for_pane(pane) ~= ""
			if has_selection then
				window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)
				window:perform_action(act.ClearSelection, pane)
			else
				window:perform_action(act({ PasteFrom = "Clipboard" }), pane)
			end
		end),
	},
}


return config
