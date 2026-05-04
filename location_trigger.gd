extends Area2D

@export var location_name: String = ""

func _ready():
	pass

func _on_body_entered(body: Node):
	if body is Player:
		task_manager.on_location_entered(location_name)

func _on_body_exited(body: Node):
	if body is Player:
		task_manager.on_location_exited(location_name)
