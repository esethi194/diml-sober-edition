extends collectibleBase

@export var BULLET_SCENE: PackedScene

func _on_body_entered(body):	
	if body.is_in_group("player"):
		body.takeHealth(10) 
		emit_signal("sobrietyChanged")
		emit_signal("collected")
		boss_task_manager.on_interaction("mirror")
		body.BULLET_SCENE = preload("res://boss1/mirror_bullet.tscn")
		queue_free()
 
