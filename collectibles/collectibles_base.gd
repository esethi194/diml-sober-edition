extends Area2D
class_name collectibleBase

signal collected
signal sobrietyChanged

@export var sobriety_restore: int = 4

func award_score_once() -> void:
	if get_meta("score_awarded", false):
		return
	set_meta("score_awarded", true)
	
	var score_manager = get_tree().get_first_node_in_group("score_manager")
	if score_manager:
		score_manager.addCollectible()
		
func _on_body_entered(body):
	if body.is_in_group("player"):
		if sobriety_restore > 0 and body.has_method("takeHealth"):
			body.takeHealth(sobriety_restore)
			emit_signal("sobrietyChanged")
		
		award_score_once()
		emit_signal("collected")
		queue_free()
