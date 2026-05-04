extends Area2D
var room_name: String = "kitchen"

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("player"):
			var enemies = get_tree().get_nodes_in_group(room_name)
			for enemy in enemies:
				if enemy.is_in_group("meany"):
					if enemy.state_machine:
						enemy.state_machine.change_state("stare")
					else:
						push_warning("[KITCHEN] No state_machine on " + enemy.name)

func _on_body_exited(body):
		if body.is_in_group("player"):
			for enemy in get_tree().get_nodes_in_group(room_name):
				if enemy.is_in_group("meany") and enemy.state_machine:
					enemy.state_machine.change_state("patrol")
