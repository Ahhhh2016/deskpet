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
func _ready():
	dialog_trigger_btn.hide()
	inputbox.hide()
	send_btn.hide()
	study_btn.hide()
	exit_btn.hide()
	tomato_btn.hide()
	#responsebox.hide()
	anim.play("star_shining")
	set_process_input(true)  # 启用输入检测
	inputbox.connect("gui_input", Callable(self, "_on_inputbox_gui_input"))

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var mouse_pos = event.position
		if is_mouse_over_pet(mouse_pos):
			show_icon()  
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
	show_icon()
	#ai_chat.send_message("你好")

func show_icon():
	dialog_trigger_btn.show()
	study_btn.show()
	exit_btn.show()
	anim.set_process_input(false)  # 禁止宠物继续接受输入，避免重复点击


func _on_button_pressed() -> void:
	inputbox.show()
	send_btn.show()
	dialog_trigger_btn.hide()  # 点击后隐藏图标


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
	get_tree().quit()  # 退出软件
	
func start_study_mode():
	anim.play("reading_book")  
	dialog_trigger_btn.hide()
	study_btn.hide()
	exit_btn.hide()
	tomato_btn.show()
	
	


func _on_tomato_button_pressed() -> void:
	timer.start_pomodoro_timer()
