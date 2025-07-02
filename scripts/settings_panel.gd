extends Control

@onready var api_key_input = $ApiKeyInput
@onready var mute_checkbtn = $MuteCheckButton
@onready var save_btn = $SaveButton
@onready var back_btn = $BackButton
var is_muted: bool = false

signal settings_saved(api_key: String, is_muted: bool)
signal back_pressed()

func _ready():
	load_settings()

func set_initial_values(api_key: String, is_muted: bool):
	api_key_input.text = api_key
	mute_checkbtn.button_pressed = is_muted
	load_settings()

func _on_save_button_pressed() -> void:
	var key = api_key_input.text.strip_edges()
	if key != "":
		save_settings(key, mute_checkbtn.button_pressed)
		emit_signal("settings_saved", key, mute_checkbtn.button_pressed)
		hide()

func _on_quit_button_pressed() -> void:
	emit_signal("back_pressed")
	hide()


func _on_mute_check_button_toggled(toggled_on: bool) -> void:
	toggled_on = is_muted

# Save API key and mute setting to local config file
func save_settings(key: String, muted: bool):
	var config = ConfigFile.new()
	config.set_value("auth", "api_key", key)
	config.set_value("preferences", "is_muted", muted)
	config.save("user://settings.cfg")

func load_settings():
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	# macos path: /Users/<你的用户名>/Library/Application Support/Godot/app_userdata/deskpet-seiko/settings.cfg
	# win path: C:\Users\<你的用户名>\AppData\Roaming\Godot\app_userdata\deskpet-seiko\settings.cfg
	# linux path: /home/<你的用户名>/.local/share/godot/app_userdata/deskpet-seiko/settings.cfg
	
	if err != OK:
		print("配置文件不存在，使用默认设置。")
		api_key_input.text = ""
		is_muted = false
		return
		
	var key = config.get_value("auth", "api_key", "")
	var muted = config.get_value("preferences", "is_muted", false)
	api_key_input.text = str(key)
	mute_checkbtn.button_pressed = muted
	is_muted = muted  # for consistency

func get_api_key() -> String:
	return api_key_input.text.strip_edges()
