extends Area2D
var room_name: String = "pool"

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("player"):
		var enemies = get_tree().get_nodes_in_group(room_name)
		for enemy in enemies:
			if not enemy.is_in_group("enemies"):
				continue
				
			if enemy.is_in_group("jock"):
				enemy.state_machine.change_state("chase")
			if enemy.is_in_group("meany"):
				enemy.state_machine.change_state("stare")
			if enemy.is_in_group("druggie"):
				enemy.state_machine.change_state("circle")
			
func _on_body_exited(body):
	if body.is_in_group("player"):
		var enemies = get_tree().get_nodes_in_group(room_name)
		for enemy in enemies:
			if not enemy.is_in_group("enemies"):
				continue
			enemy.state_machine.change_state("patrol")
