---@diagnostic disable-next-line: undefined-global
local hl = hl

hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

hl.workspace_rule({ workspace = "4", monitor = "eDP-1", default = true })
for i = 1, 9 do
	if i ~= 4 then
		hl.workspace_rule({ workspace = tostring(i), monitor = "HDMI-A-1", default = i == 1 })
	end
end

local terminal = "ghostty"
local menu = "fuzzel"
local browser = "zen-browser"

hl.on("hyprland.start", function()
	hl.exec_cmd("quickshell --no-duplicate")
	hl.exec_cmd("hyprpaper")
end)

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 10,
		border_size = 2,
		col = {
			active_border = "rgba(313244ff)",
			inactive_border = "rgba(1e1e2eff)",
		},
		resize_on_border = false,
		allow_tearing = false,
		layout = "dwindle",
	},
	decoration = {
		rounding_power = 0,
		active_opacity = 1.0,
		inactive_opacity = 1.0,
		blur = {
			enabled = true,
			size = 3,
			passes = 2,
			vibrancy = 0.1696,
		},
	},
	animations = { enabled = true },
	dwindle = { preserve_split = true },
	master = { new_status = "master" },
	misc = {
		force_default_wallpaper = 0,
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		middle_click_paste = false,
	},
	input = {
		kb_layout = "pl",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",
		follow_mouse = 1,
		sensitivity = 0,
		touchpad = {
			natural_scroll = true,
			tap_to_click = true,
			tap_and_drag = true,
			drag_lock = 1,
			drag_3fg = 1,
		},
	},
})

hl.curve("easeOut", { type = "bezier", points = { { 0.16, 1.0 }, { 0.3, 1.0 } } })
hl.curve("easeIn", { type = "bezier", points = { { 0.7, 0.0 }, { 0.84, 0.0 } } })
hl.animation({ leaf = "global", enabled = true, speed = 2.2, bezier = "easeOut" })
hl.animation({ leaf = "windows", enabled = true, speed = 2.2, bezier = "easeOut" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.8, bezier = "easeIn" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2.2, bezier = "easeOut" })

hl.device({ name = "logitech-usb-optical-mouse", sensitivity = -0.35 })
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

local mainMod = "SUPER"
local function exec(keys, command, flags)
	hl.bind(keys, hl.dsp.exec_cmd(command), flags)
end

exec(mainMod .. " + RETURN", terminal .. " +new-window")
exec(mainMod .. " + Z", "zed")
hl.bind(mainMod .. " + X", hl.dsp.window.close())
exec(
	mainMod .. " + Q",
	[[wlogout --layout "$HOME/.config/hypr/wlogout-layout" --css "$HOME/.config/hypr/wlogout-style.css" --buttons-per-row 2 --no-span]]
)
exec(mainMod .. " + B", browser)
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
exec(mainMod .. " + D", menu)
hl.bind(mainMod .. " + SPACE", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
exec(
	"PRINT",
	[[mkdir -p "$HOME/Pictures/Screenshots"; grim "$HOME/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png"; notify-send "Screenshot saved"]]
)
exec(mainMod .. " + SHIFT + S", [[grim -g "$(slurp)" - | wl-copy; notify-send "Screenshot copied"]])
exec(
	mainMod .. " + SHIFT + R",
	[[if pgrep -x wf-recorder >/dev/null 2>&1; then pkill -INT wf-recorder; notify-send "Recording stopped"; elif command -v wf-recorder >/dev/null 2>&1; then mkdir -p "$HOME/Videos/Recordings"; wf-recorder -f "$HOME/Videos/Recordings/$(date +%Y-%m-%d_%H-%M-%S).mp4" >/tmp/wf-recorder.log 2>&1 & notify-send "Recording started"; else notify-send "wf-recorder is not installed"; fi]]
)
exec(
	mainMod .. " + CTRL + R",
	[[if pgrep -x wf-recorder >/dev/null 2>&1; then pkill -INT wf-recorder; notify-send "Recording stopped"; elif command -v wf-recorder >/dev/null 2>&1; then mkdir -p "$HOME/Videos/Recordings"; region="$(slurp)" && { wf-recorder -g "$region" -f "$HOME/Videos/Recordings/$(date +%Y-%m-%d_%H-%M-%S).mp4" >/tmp/wf-recorder.log 2>&1 & notify-send "Recording started"; }; else notify-send "wf-recorder is not installed"; fi]]
)

for key, direction in pairs({ H = "left", L = "right", K = "up", J = "down" }) do
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ direction = direction }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ direction = direction }))
end

for i = 1, 10 do
	local key = i % 10
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

exec("XF86AudioRaiseVolume", "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+", { locked = true, repeating = true })
exec("XF86AudioLowerVolume", "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-", { locked = true, repeating = true })
exec("XF86AudioMute", "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle", { locked = true, repeating = true })
exec("XF86AudioMicMute", "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle", { locked = true, repeating = true })
exec("XF86MonBrightnessUp", "brightnessctl -e4 -n2 set 5%+", { locked = true, repeating = true })
exec("XF86MonBrightnessDown", "brightnessctl -e4 -n2 set 5%-", { locked = true, repeating = true })
exec("XF86AudioNext", "playerctl next", { locked = true })
exec("XF86AudioPause", "playerctl play-pause", { locked = true })
exec("XF86AudioPlay", "playerctl play-pause", { locked = true })
exec("XF86AudioPrev", "playerctl previous", { locked = true })

hl.layer_rule({
	name = "blur-quickshell",
	match = { namespace = "quickshell" },
	blur = true,
	ignore_alpha = 0.1,
})

hl.window_rule({
	name = "suppress-maximize-events",
	match = { class = ".*" },
	suppress_event = "maximize",
})

hl.window_rule({
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})

hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },
	move = "20 monitor_h-120",
	float = true,
})
