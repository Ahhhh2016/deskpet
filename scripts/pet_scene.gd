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

	
var idle_time = 0.0
const IDLE_THRESHOLD = 30.0
const HIDE_MENU_THRESHOLD = 3.0
var last_mouse_pos = Vector2.ZERO
var is_sleeping = false
var is_jumping = false
var is_studying = false
var is_chatting = false
var is_showing_menu = false


func _ready():
	helloAudio.play()
	dialog_trigger_btn.hide()
	inputbox.hide()
	send_btn.hide()
	study_btn.hide()
	exit_btn.hide()
	tomato_btn.hide()
	menu_btn.hide()
	timer.yes_btn.hide()
	timer.no_btn.hide()
	responsebox.hide()
	anim.play("idle")
	set_process_input(true)  # 启用输入检测
	inputbox.connect("gui_input", Callable(self, "_on_inputbox_gui_input"))
	anim.connect("animation_finished", Callable(self, "_on_animation_finished"))

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var mouse_pos = event.position
		if is_mouse_over_pet(mouse_pos):
			#show_menu()  
			_on_pet_click() # 检查鼠标是否点在宠物上

func is_mouse_over_pet(mouse_pos: Vector2) -> bool:
	var sprite_rect = Rect2(
		anim.global_position - (anim.sprite_frames.get_frame_texture(anim.animation, 0).get_size() * 0.5),
		anim.sprite_frames.get_frame_texture(anim.animation, 0).get_size()
	)
	return sprite_rect.has_point(mouse_pos)

#func _process(delta):
	#var mouse_pos = get_viewport().get_mouse_position()
	#position = position.lerp(mouse_pos, 100 * delta)
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
	anim.set_process_input(false)  # 禁止宠物继续接受输入，避免重复点击


func _on_dialog_button_pressed() -> void:
	inputbox.show()
	send_btn.show()
	anim.play("star_shining")
	dialog_trigger_btn.hide()  # 点击后隐藏图标
	study_btn.hide()
	exit_btn.hide()
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
	responsebox.show()

func _on_tomato_button_pressed() -> void:
	timer.start_pomodoro_timer()


func _on_menu_button_pressed() -> void:
	show_menu()


func _process(delta):
	idle_time += delta
	var mouse_pos = get_viewport().get_mouse_position()
	var is_hovering = is_mouse_over_pet(mouse_pos)

	# 鼠标移动时重置 idle_time
	if mouse_pos != last_mouse_pos:
		idle_time = 0.0
		last_mouse_pos = mouse_pos
	
	if idle_time >= HIDE_MENU_THRESHOLD and is_showing_menu:
		dialog_trigger_btn.hide()
		exit_btn.hide()
		study_btn.hide()
	
	# 如果悬停且当前是 sleeping 状态
	if is_hovering and is_sleeping:
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

#func _on_animation_finished():
	#if anim.animation == "jumping":
		#print(anim.animation)
		#anim.play("idle")
		#is_jumping = false
		#return


func _on_animated_sprite_2d_animation_looped() -> void:
	if anim.animation == "jumping":
		print(anim.animation)
		anim.play("idle")
		is_jumping = false
		return
