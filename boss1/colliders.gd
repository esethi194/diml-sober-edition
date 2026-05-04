extends StaticBody2D

@onready var bullet_detector = $Area2D

func _ready():
	pass
	
func _on_bullet_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		area.queue_free()
