extends TextureProgressBar

signal end_of_bosslevel

const TOTAL_TIME := 120  # set to 120 
var time_left := TOTAL_TIME
var timeout_started := false
const TIMEOUT_DELAY := 1.0

func _ready():
	max_value = 100
	value = max_value
	time_left = TOTAL_TIME
	$Label.text = "02:00"   # update for 120s
	$Timer.start()

func _on_timer_timeout() -> void:
	time_left -= 1

	# linear progress bar update
	value = max_value * float(time_left) / float(TOTAL_TIME)

	# update label
	var mins = time_left / 60
	var secs = time_left % 60
	$Label.text = "%02d:%02d" % [mins, secs]

	if time_left <= 0:
		endTimer()

func endTimer():
	if timeout_started:
		return
	timeout_started = true
	
	$Timer.stop()
	emit_signal("end_of_bosslevel")
	task_manager.restart_all_tasks()
	await get_tree().create_timer(TIMEOUT_DELAY).timeout
	get_tree().change_scene_to_file("res://sprites/ui/relapse/timeout_UI.tscn")
