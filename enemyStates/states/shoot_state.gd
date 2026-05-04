extends EnemyState
class_name ShootState

func enter() -> void:
	var shoot_timer = enemy.get_node_or_null("ShootTimer")
	if shoot_timer:
		shoot_timer.start()

func exit() -> void:
	var shoot_timer = enemy.get_node_or_null("ShootTimer")
	if shoot_timer:
		shoot_timer.stop()

func physics_update(delta: float) -> void:
	if not enemy.player:
		return
	
	var dir_vector = (enemy.player.global_position - enemy.global_position).normalized()
	enemy.global_position += dir_vector * enemy.chase_speed * delta
	enemy.move_and_slide()
	
	if enemy.sprite is Sprite2D:
		enemy.sprite.flip_h = (dir_vector.x < 0)
