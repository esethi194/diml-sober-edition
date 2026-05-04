class_name SobrietyManagerBoss
extends SobrietyManagerBase

var drain_rate_per_second := 10
var drain_paused := false
var pause_duration := 3.0
var pause_timer := 0.0

func _process(delta: float) -> void:
	if not drain_paused:
		takeDamage(drain_rate_per_second * delta)
	else:
		pause_timer -= delta
		if pause_timer <= 0:
			drain_paused = false

func pause_drain():
	drain_paused = true
	pause_timer = pause_duration

# override relapse — boss fight uses different lose scene
func handleRelapse() -> void:
	if relapse_started:
		return
	relapse_started = true
	
	emit_signal("relapsed")
	await get_tree().create_timer(GAME_OVER_DELAY).timeout
	get_tree().change_scene_to_file("res://sprites/ui/relapse/relapse_UI.tscn")
