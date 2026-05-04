class_name StareState
extends EnemyState

var stare_duration := 3.0  # Changed to 3 seconds
var time_elapsed := 0.0

func enter() -> void:
	enemy.active = true
	time_elapsed = 0.0
	
	var shoot_timer = enemy.get_node_or_null("ShootTimer")
	if shoot_timer:
		shoot_timer.stop()

func exit() -> void:
	pass

func physics_update(delta: float) -> void:
	time_elapsed += delta
	
	if not enemy.player:
		enemy.player = enemy.get_tree().get_first_node_in_group("player") as Node2D
	
	if enemy.player and enemy.sprite is Sprite2D:
		var look_vec = enemy.player.global_position - enemy.global_position
		enemy.sprite.flip_h = (look_vec.x < 0)
	
	if time_elapsed >= stare_duration:
		enemy.state_machine.change_state("chase")
