extends Timer

@onready var responsebox = $"../ResponseBox"
@onready var tomato_btn = $"../TomatoButton"
var study_time = 25 * 60  # 25分钟

var remaining_time = study_time

func start_pomodoro_timer():
	tomato_btn.hide()
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

func _on_Timer_timeout():
	responsebox.text = "休息一下吧！☕️ 你太棒啦～"

func update_responsebox():
	var minutes = int(remaining_time) / 60
	var seconds = int(remaining_time) % 60
	responsebox.text = "番茄钟启动啦！ 专注 %02d 分 %02d 秒～ ⏳" % [minutes, seconds]
	
