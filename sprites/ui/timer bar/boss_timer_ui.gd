extends TextureProgressBar

signal  end_of_bosslevel
@onready var player : Player = null
var total_time_in_secs : int = 10
#var step : float = 100.0 / 180.0  # This defines how much to subtract each second

func _ready():
	$bossTImer.start()


func endTimer():
	emit_signal("end_of_bosslevel")
	$bossTImer.queue_free()
	


func _on_boss_timer_timeout() -> void:
	step = 100.0 / 60.0  # This defines how much to subtract each second
	value -= step  # Decrease by the step value each second
	total_time_in_secs -= 1
	
	# Update the time label (min:sec format)
	var mins = int(total_time_in_secs / 60.0)
	var secs = total_time_in_secs - mins * 60
	$Label.text = '%02d:%02d' % [mins, secs]
	
	# If the timer reaches zero, end it
	if total_time_in_secs <= 0:
		endTimer()
