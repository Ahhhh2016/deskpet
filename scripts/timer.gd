extends Timer

@onready var responsebox = $"../ResponseBox"
@onready var tomato_btn = $"../TomatoButton"
@onready var menu_btn = $"../MenuButton"
@onready var sugoi = $"../SugoiAudio"
@onready var anim = $"../AnimatedSprite2D"
@onready var yes_btn = $YesButton
@onready var no_btn = $NoButton
@onready var parent_node = get_parent()
#var study_time = 25 * 60  # 25分钟
var study_time = 5

var is_study = false

var remaining_time = study_time

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var mouse_pos = event.position
		if is_mouse_over_pet(mouse_pos) and parent_node.is_studying == true:
			#show_menu()  
			_on_pet_click() # 检查鼠标是否点在宠物上

func is_mouse_over_pet(mouse_pos: Vector2) -> bool:
	var sprite_rect = Rect2(
		anim.global_position - (anim.sprite_frames.get_frame_texture(anim.animation, 0).get_size() * 0.5),
		anim.sprite_frames.get_frame_texture(anim.animation, 0).get_size()
	)
	return sprite_rect.has_point(mouse_pos)

func _on_pet_click():
	set_process(false)
	print("click")
	yes_btn.show()
	no_btn.show()
	#responsebox.show()
	responsebox.text = "确定要退出了吗？不再学一会儿了吗～🥺"
	
	

func start_pomodoro_timer():
	tomato_btn.hide()
	menu_btn.hide()
	yes_btn.hide()
	no_btn.hide()
	wait_time = study_time
	remaining_time = study_time
	start()
	set_process(true)
	update_responsebox()

func _process(delta):
	if time_left > 0:
		remaining_time = time_left
		update_responsebox()
	else:
		set_process(false)


func update_responsebox():
	var minutes = int(remaining_time) / 60
	var seconds = int(remaining_time) % 60
	responsebox.text = "番茄钟启动！ 继续专注 %02d 分 %02d 秒～ ⏳" % [minutes, seconds]
	


func _on_timeout() -> void:
	responsebox.text = "休息一下吧！☕️ 你太棒啦～"
	if not parent_node.is_muted:
		print(parent_node.is_muted)
		sugoi.play()
	tomato_btn.show()
	menu_btn.show()


func _on_yes_button_pressed() -> void:
	yes_btn.hide()
	no_btn.hide()
	#parent_node.show_menu()
	responsebox.text = ""
	#tomato_btn.show()
	#menu_btn.show()
	parent_node.start_study_mode()
	

func _on_no_button_pressed() -> void:
	yes_btn.hide()
	no_btn.hide()
	set_process(true)
	update_responsebox()
