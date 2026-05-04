class_name PatrolState
extends EnemyState

func enter() -> void:
	enemy.active = false
	enemy.velocity = Vector2.ZERO

func exit() -> void:
	pass

func physics_update(delta: float) -> void:
	if enemy == null:
		return
		
	var target_x = enemy.start_position.x + enemy.patrol_distance * enemy.patrol_direction
	var distance = abs(enemy.global_position.x - target_x)
	
	# Check if reached patrol point
	if distance < 5:
		enemy.patrol_direction *= -1
		target_x = enemy.start_position.x + enemy.patrol_distance * enemy.patrol_direction
	
	# Move toward target
	var direction = sign(target_x - enemy.global_position.x)
	if direction == 0:
		enemy.patrol_direction *= -1
		direction = enemy.patrol_direction
	enemy.velocity.x = direction * enemy.patrol_speed
	enemy.velocity.y = 0
	enemy.move_and_slide()
	
	if enemy.is_on_wall():
		enemy.patrol_direction *= -1
	
	# Flip sprite using base class helper
	var dir_vector = Vector2(enemy.velocity.x, 0)
	handle_sprite_flip(dir_vector)
