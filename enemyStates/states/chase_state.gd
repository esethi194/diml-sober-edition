class_name ChaseState
extends EnemyState

func enter() -> void:
	enemy.active = true
	var shoot_timer = enemy.get_node_or_null("ShootTimer")
	if shoot_timer:
		shoot_timer.start()
		
func exit() -> void:
	var shoot_timer = enemy.get_node_or_null("ShootTimer")
	if shoot_timer:
		shoot_timer.stop()

func physics_update(delta: float) -> void:
	if not enemy.player:
		enemy.player = enemy.get_tree().get_first_node_in_group("player") as Node2D
		if not enemy.player:
			return
	
	var dir_vector = (enemy.player.global_position - enemy.global_position).normalized()
	enemy.velocity = dir_vector * enemy.chase_speed
	enemy.move_and_slide()

	# Flip sprite
	if enemy.sprite is Sprite2D and enemy.velocity.x != 0.0:
		enemy.sprite.flip_h = enemy.velocity.x < 0.0
		enemy.sprite.flip_h = (enemy.velocity.x < 0)
