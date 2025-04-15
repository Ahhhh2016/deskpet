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
@onready var ai_chat = $AIChat # 预加载 AI 交互脚本$AIChat
@onready var timer = $Timer
@onready var byeAudio = $AaaAudio
@onready var oiAudio = $OiAudio
@onready var helloAudio = $KonnichiwaAudio
@onready var settings_panel = $SettingsPanel
@onready var settings_btn = $SettingsButton

var api_key: String = ""
var is_muted: bool = false
	
var idle_time = 0.0
const IDLE_THRESHOLD = 5.0
const HIDE_MENU_THRESHOLD = 3.0
var last_mouse_pos = Vector2.ZERO
var is_sleeping = false
var is_jumping = false
var is_studying = false
var is_chatting = false
var is_showing_menu = false

var dragging = false
var drag_offset = Vector2.ZERO
var click_start_time := 0.0
var click_start_pos := Vector2.ZERO
const DRAG_DISTANCE_THRESHOLD := 10.0
const CLICK_TIME_THRESHOLD := 0.2

func _ready():
	settings_panel.settings_saved.connect(_on_settings_saved)
	settings_panel.back_pressed.connect(_on_settings_back)

	# 加载设置面板的初始值
	settings_panel.load_settings()
	api_key = settings_panel.api_key_input.text
	is_muted = settings_panel.is_muted
	
	# 设置背景透明和一直置于顶层
	get_window().always_on_top = true
	get_window().set_transparent_background(true)
	
	if not is_muted:
		helloAudio.play()
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
	anim.play("idle")
	set_process_input(true)  # 启用输入检测
	inputbox.connect("gui_input", Callable(self, "_on_inputbox_gui_input"))
	anim.connect("animation_finished", Callable(self, "_on_animation_finished"))
	
	if api_key == "":
		print("has no api key")
		settings_panel.show()
	else:
		ai_chat.set_api_key(api_key)
		settings_panel.hide()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				var mouse_pos = event.position
				if is_mouse_over_pet(mouse_pos):
					click_start_time = Time.get_ticks_msec() / 1000.0
					click_start_pos = mouse_pos
					dragging = true
					drag_offset = global_position - mouse_pos
			else:
				var click_duration = Time.get_ticks_msec() / 1000.0 - click_start_time
				var move_distance = click_start_pos.distance_to(event.position)
				if click_duration < CLICK_TIME_THRESHOLD and move_distance < DRAG_DISTANCE_THRESHOLD:
					_on_pet_click() # 判定为点击
				dragging = false

	elif event is InputEventMouseMotion and dragging:
		global_position = event.position + drag_offset


func is_mouse_over_pet(mouse_pos: Vector2) -> bool:
	var sprite_rect = Rect2(
		anim.global_position - (anim.sprite_frames.get_frame_texture(anim.animation, 0).get_size() * 0.5),
		anim.sprite_frames.get_frame_texture(anim.animation, 0).get_size()
	)
	return sprite_rect.has_point(mouse_pos)

func _on_pet_click():
	if not is_studying:
		anim.play("idle")
		show_menu()
	#ai_chat.send_message("你好")

func show_menu():
	anim.play("idle")
	is_sleeping = false
	is_studying = false
	is_chatting = false
	menu_btn.position = Vector2(717, 400)  # 改成你想要的位置
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
	anim.set_process_input(false)  # 禁止宠物继续接受输入，避免重复点击


func _on_dialog_button_pressed() -> void:
	inputbox.show()
	send_btn.show()
	anim.play("star_shining")
	dialog_trigger_btn.hide()  # 点击后隐藏图标
	study_btn.hide()
	exit_btn.hide()
	settings_btn.hide()
	menu_btn.position = Vector2(433, 425)  # 改成你想要的位置
	menu_btn.size = Vector2(30, 45)
	menu_btn.show()
	is_chatting = true
	


func _on_send_button_pressed() -> void:
	var message = inputbox.text
	if message != "":
		#append_to_chat("你: " + message)
		ai_chat.send_message(message)  # 发送消息到 AI
		inputbox.clear()  # 清空输入框

func _on_inputbox_gui_input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		# 检查是否是回车（Enter 或 Return）
		if event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER:
			_on_send_button_pressed()
			
func _on_study_button_pressed() -> void:
	start_study_mode()
	
func _on_exit_button_pressed() -> void:
	if not is_muted:
		byeAudio.play()
	await get_tree().create_timer(1.0).timeout  # 等待 2 秒
	get_tree().quit() # 退出软件
	
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


func _process(delta):
	idle_time += delta
	var mouse_pos = get_viewport().get_mouse_position()
	var is_hovering = is_mouse_over_pet(mouse_pos)

	if dragging and not is_studying and not is_chatting:
		anim.play("busy")
		var screen_size = get_viewport().get_visible_rect().size
		position.x = clamp(position.x, 0, screen_size.x)
		position.y = clamp(position.y, 0, screen_size.y)
		dialog_trigger_btn.hide()
		study_btn.hide()
		exit_btn.hide()
		settings_btn.hide()
		
	# 鼠标移动时重置 idle_time
	if mouse_pos != last_mouse_pos:
		idle_time = 0.0
		last_mouse_pos = mouse_pos
	
	if idle_time >= HIDE_MENU_THRESHOLD and is_showing_menu:
		dialog_trigger_btn.hide()
		exit_btn.hide()
		study_btn.hide()
		settings_btn.hide()
	
	# 如果悬停且当前是 sleeping 状态
	if is_hovering and not dragging and not is_studying and not is_chatting:
		if not is_muted:
			oiAudio.play()
		anim.play("jumping")
		is_sleeping = false
		is_jumping = true
		idle_time = 0.0 # 唤醒时重置 idle_time
		return # 立即返回，避免在同一帧内再次触发 jumping

	# 长时间没有鼠标悬停且不是 sleeping 状态，进入 sleeping 状态
	elif idle_time >= IDLE_THRESHOLD and not is_sleeping and not is_hovering and not is_jumping and not is_studying and not is_chatting:
		anim.play("sleeping")
		is_sleeping = true

	# 如果当前动画不是 idle 且 idle_time 小于阈值，并且不在 jumping 状态，则播放 idle 动画
	elif anim.animation != "idle" and idle_time < IDLE_THRESHOLD and not is_jumping and not is_sleeping and not is_studying and not is_chatting:
		anim.play("idle")

	# 如果当前是 idle 状态，重置 idle_time，确保在 idle 时移动鼠标也能重置
	elif anim.animation == "idle" and is_hovering:
		idle_time = 0.0


func _on_animated_sprite_2d_animation_looped() -> void:
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

func _on_settings_back():
	settings_panel.hide()


func _on_settings_button_pressed() -> void:
	#settings_panel.set_initial_values(api_key, is_muted)
	settings_panel.show()
	
#func has_api_key() -> bool:
	#var config = ConfigFile.new()
	#var err = config.load("user://settings.cfg")
	#if err != OK:
		#return false
	#print("🔍 Loaded api_key:", api_key, "（长度：", api_key.length(), "）")
	#return config.has_section_key("auth", "api_key") and config.get_value("auth", "api_key", "").strip_edges().length() > 0
