extends Node2D

@export var area_name: String = ""

func _ready():
	# Auto-set area_name based on node name if not set
	if area_name == "":
		area_name = name.to_lower()

func _on_body_entered(body):
	if body.is_in_group("player"):
		# Notify all enemies about player entering this area
		var enemies = get_tree().get_nodes_in_group("enemies")
		for enemy in enemies:
			if enemy.has_method("_on_area_entered"):
				enemy._on_area_entered(area_name, body)

func _on_body_exited(body):
	if body.is_in_group("player"):
		# Notify all enemies about player exiting this area
		var enemies = get_tree().get_nodes_in_group("enemies")
		for enemy in enemies:
			if enemy.has_method("_on_area_exited"):
				enemy._on_area_exited(area_name, body)
