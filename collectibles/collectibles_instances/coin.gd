extends collectibleBase

signal collected_coin
var win_started := false
const WIN_DELAY := 1.0

func _on_body_entered(body):
	if not body.is_in_group("player") or win_started:
		return
	
	win_started = true
	emit_signal("collected_coin")
	boss_task_manager.on_interaction("coin")
	await get_tree().create_timer(WIN_DELAY).timeout
	get_tree().change_scene_to_file("res://win.tscn")
	queue_free()
