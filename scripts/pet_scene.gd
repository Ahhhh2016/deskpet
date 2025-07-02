extends Node2D

@onready var anim = $AnimatedSprite2D
@onready var dialog_trigger_btn = $DialogButton
@onready var inputbox = $InputBox
@onready var responsebox = $ResponseBox
@onready var send_btn = $SendButton
@onready var study_btn = $StudyButton
@onready var exit_btn = $ExitButton
@onready var menu_btn = $MenuButton
@onready var tomato_btn = $TomatoButton
@onready var ai_chat = $AIChat # Preload AI interaction scripts
@onready var timer = $Timer
@onready var byeAudio = $AaaAudio
@onready var oiAudio = $OiAudio
@onready var helloAudio = $KonnichiwaAudio
@onready var settings_panel = $SettingsPanel
@onready var settings_btn = $SettingsButton
@onready var polygon_alpha_btn: Polygon2D = $polygonAlphaBtn # Polygon2D Node
@onready var polygon_alpha_chat: Polygon2D = $polygonAlphaChat
@onready var polygon_alpha_setting: Polygon2D = $polygonAlphaSetting

# Config and state variables
var api_key: String = ""
var is_muted: bool = false
var idle_time = 0.0
var last_mouse_pos = Vector2.ZERO
var is_sleeping = false
var is_jumping = false
var is_studying = false
var is_onsetting = false
var is_chatting = false
var is_showing_menu = false

# Drag and click tracking
var dragging = false
var drag_offset = Vector2.ZERO
var click_start_time := 0.0
var click_start_pos := Vector2.ZERO

# Constants
const DRAG_DISTANCE_THRESHOLD := 10.0
const CLICK_TIME_THRESHOLD := 0.2
const IDLE_THRESHOLD = 5.0
const HIDE_MENU_THRESHOLD = 3.0


func _ready():
	# Connect settings panel signals
	settings_panel.settings_saved.connect(_on_settings_saved)
	settings_panel.back_pressed.connect(_on_settings_back)
	# Load the initial values ​​of the settings panel
	settings_panel.load_settings()
	
	api_key = settings_panel.api_key_input.text
	is_muted = settings_panel.is_muted

	# Set the background to be transparent and always on top
	get_window().always_on_top = true
	get_window().set_transparent_background(true)
	get_window().borderless = true
	DisplayServer.window_set_mouse_passthrough(polygon_alpha_btn.polygon)

	if not is_muted:
		helloAudio.play()
	
	# hide all ui
	dialog_trigger_btn.hide()
	inputbox.hide()
	send_btn.hide()
	study_btn.hide()
	exit_btn.hide()
	tomato_btn.hide()
	menu_btn.hide()
	settings_btn.hide()
	timer.yes_btn.hide()
	timer.no_btn.hide()
	responsebox.hide()
	
	# Enable input detection
	set_process_input(true)  
	inputbox.connect("gui_input", Callable(self, "_on_inputbox_gui_input"))
		
	anim.play("idle")
	anim.connect("animation_finished", Callable(self, "_on_animation_finished"))

	# Show settings if API key is missing
	if api_key == "":
		print("Has no api key.")
		is_onsetting = true
		settings_panel.show()
		DisplayServer.window_set_mouse_passthrough(polygon_alpha_setting.polygon)
	else:
		ai_chat.set_api_key(api_key)
		settings_panel.hide()
		is_onsetting = false

func _input(event):
	if event is InputEventMouseButton:
		handle_mouse_button(event)
	elif event is InputEventMouseMotion and dragging:
		update_drag_position(event)
	
func handle_mouse_button(event):
	# Left click: detect quick click over pet to open menu
	# Right click: begin dragging the window
	
	if event.button_index == MOUSE_BUTTON_LEFT and not is_chatting and not is_studying and not is_onsetting:
		if event.pressed:
			var mouse_pos = event.position
			click_start_time = Time.get_ticks_msec() / 1000.0
			click_start_pos = mouse_pos
		else:
			var click_duration = Time.get_ticks_msec() / 1000.0 - click_start_time
			var move_distance = click_start_pos.distance_to(event.position)
			if click_duration < CLICK_TIME_THRESHOLD and move_distance < DRAG_DISTANCE_THRESHOLD and is_mouse_over_pet(event.position):
				_on_pet_click() # Determines if it is left clicked
			click_start_time = 0.0 # Reset click start time
			click_start_pos = Vector2.ZERO # Reset click start position
			dragging = false # Cancel the drag state

	elif event.button_index == MOUSE_BUTTON_RIGHT:
		if event.pressed:
			dragging = true
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			drag_offset = get_global_mouse_position() - Vector2(get_window().get_position())
		else:
			dragging = false 
			anim.play("idle")
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func update_drag_position(event):
	var relative_motion = event.relative
	var current_window_position = DisplayServer.window_get_position()
	var new_window_position = Vector2(current_window_position) + relative_motion
	DisplayServer.window_set_position(new_window_position.floor())
			
func is_mouse_over_pet(mouse_pos: Vector2) -> bool:
	var sprite_rect = Rect2(
		anim.global_position - (anim.sprite_frames.get_frame_texture(anim.animation, 0).get_size() * 0.5),
		anim.sprite_frames.get_frame_texture(anim.animation, 0).get_size()
	)
	return sprite_rect.has_point(mouse_pos)

func _on_pet_click():
	# Wakes up pet and shows interaction menu
	if not is_studying and not is_chatting:
		anim.play("idle")
		show_menu()

func show_menu():
	anim.play("idle")
	DisplayServer.window_set_mouse_passthrough(polygon_alpha_btn.polygon)

	is_sleeping = false
	is_studying = false
	is_chatting = false
	menu_btn.position = Vector2(717, 400)  
	menu_btn.size = Vector2(30, 30)
	is_showing_menu = true
	tomato_btn.hide()
	menu_btn.hide()
	responsebox.hide()
	inputbox.hide()
	send_btn.hide()
	dialog_trigger_btn.show()
	study_btn.show()
	exit_btn.show()
	settings_btn.show()
	anim.set_process_input(false)  # Prevent the pet from continuing to accept input to avoid repeated clicks


func _on_dialog_button_pressed() -> void:
	inputbox.show()
	send_btn.show()
	anim.play("star_shining")
	dialog_trigger_btn.hide()  
	study_btn.hide()
	exit_btn.hide()
	settings_btn.hide()
	menu_btn.position = Vector2(433, 425) 
	menu_btn.size = Vector2(30, 45)
	menu_btn.show()
	is_chatting = true
	DisplayServer.window_set_mouse_passthrough(polygon_alpha_chat.polygon)

	

# Send user input to AI
func _on_send_button_pressed() -> void:
	var message = inputbox.text
	if message != "":
		#append_to_chat("你: " + message)
		ai_chat.send_message(message) 
		inputbox.clear()  

func _on_inputbox_gui_input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		# Check Enter or Return
		if event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER:
			_on_send_button_pressed()

func _on_study_button_pressed() -> void:
	start_study_mode()

func _on_exit_button_pressed() -> void:
	if not is_muted:
		byeAudio.play()
	await get_tree().create_timer(1.0).timeout  # Wait 2 seconds
	get_tree().quit()

func start_study_mode():
	anim.play("reading_book")
	is_studying = true
	dialog_trigger_btn.hide()
	study_btn.hide()
	exit_btn.hide()
	tomato_btn.show()
	menu_btn.show()
	settings_btn.hide()
	responsebox.show()
	responsebox.text = ""

func _on_tomato_button_pressed() -> void:
	timer.start_pomodoro_timer()


func _on_menu_button_pressed() -> void:
	show_menu()

# Core animation logic based on user interaction + inactivity
# Handles:
# - sleeping if idle
# - jumping if hovered
# - dragging state
# - hiding menu after timeout
func _process(delta):
	idle_time += delta
	var mouse_pos = get_viewport().get_mouse_position()
	var is_hovering = is_mouse_over_pet(mouse_pos)
	
	if is_chatting:
		anim.play("star_shining")

	if dragging and not is_studying and not is_chatting:
		anim.play("busy")
		var screen_size = get_viewport().get_visible_rect().size
		position.x = clamp(position.x, 0, screen_size.x)
		position.y = clamp(position.y, 0, screen_size.y)
		dialog_trigger_btn.hide()
		study_btn.hide()
		exit_btn.hide()
		settings_btn.hide()

	# Reset idle_time when mouse moves
	if mouse_pos != last_mouse_pos:
		idle_time = 0.0
		last_mouse_pos = mouse_pos

	if idle_time >= HIDE_MENU_THRESHOLD and is_showing_menu:
		dialog_trigger_btn.hide()
		exit_btn.hide()
		study_btn.hide()
		settings_btn.hide()

	# If hovering and currently in sleeping state
	if is_hovering and not dragging and not is_studying and not is_chatting:
		if not is_muted:
			oiAudio.play()
		anim.play("jumping")
		is_sleeping = false
		is_jumping = true
		idle_time = 0.0 # Reset idle_time on wakeup
		return # Return immediately to avoid triggering jumping again in the same frame

	# If not hovered for a long time and not sleeping, sleep
	elif idle_time >= IDLE_THRESHOLD and not is_sleeping and not is_hovering and not is_jumping and not is_studying and not is_chatting:
		anim.play("sleeping")
		is_sleeping = true

	# If no idle and idle_time less than threshold，and not jumping，idle
	elif anim.animation != "idle" and idle_time < IDLE_THRESHOLD and not is_jumping and not is_sleeping and not is_studying and not is_chatting:
		anim.play("idle")

	# If idle，reset idle_time，ensure that moving mouse while idle also reset idle_time
	elif anim.animation == "idle" and is_hovering:
		idle_time = 0.0


func _on_animated_sprite_2d_animation_looped() -> void:
	# Reset jumping state when animation loops
	if anim.animation == "jumping":
		#print(anim.animation)
		anim.play("idle")
		is_jumping = false
		return

func _on_settings_saved(new_api_key: String, muted: bool):
	api_key = new_api_key
	is_muted = muted
	print("新 API Key: ", api_key)
	print("是否静音: ", is_muted)
	settings_panel.hide()
	is_onsetting = false

func _on_settings_back():
	settings_panel.hide()
	is_onsetting = false


func _on_settings_button_pressed() -> void:
	#settings_panel.set_initial_values(api_key, is_muted)
	settings_panel.show()
	is_onsetting = true
	DisplayServer.window_set_mouse_passthrough(polygon_alpha_setting.polygon)
