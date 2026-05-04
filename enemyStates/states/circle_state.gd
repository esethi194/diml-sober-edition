class_name CircleState
extends EnemyState

var circle_radius := 250.0
var circle_speed := 100.0
var angle := 0.0

func enter() -> void:
	enemy.active = true
	super.enter()

func physics_update(delta: float) -> void:
	if not enemy.player:
		return
	
	# Orbit around player
	angle += (circle_speed / circle_radius) * delta
	var offset = Vector2(cos(angle), sin(angle)) * circle_radius
	var target_pos = enemy.player.global_position + offset
	
	var dir_vector = (target_pos - enemy.global_position).normalized()
	enemy.velocity = dir_vector * circle_speed
	enemy.move_and_slide()
	
	# Always face the player
	var look_at_player = enemy.player.global_position - enemy.global_position
	handle_sprite_flip(look_at_player)
