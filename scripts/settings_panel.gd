extends Control

@onready var api_key_input = $ApiKeyInput
@onready var mute_checkbtn = $MuteCheckButton
@onready var save_btn = $SaveButton
@onready var back_btn = $BackButton
var is_muted: bool = false

signal settings_saved(api_key: String, is_muted: bool)
signal back_pressed()

func set_initial_values(api_key: String, is_muted: bool):
	api_key_input.text = api_key
	mute_checkbtn.button_pressed = is_muted

func _on_save_button_pressed() -> void:
	emit_signal("settings_saved", api_key_input.text.strip_edges(), mute_checkbtn.button_pressed)


func _on_quit_button_pressed() -> void:
	emit_signal("back_pressed")


func _on_mute_check_button_toggled(toggled_on: bool) -> void:
	is_muted = toggled_on
