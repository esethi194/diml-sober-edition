class_name EnemyState
extends Node

var enemy;
var state_machine;

func enter() -> void:
	if enemy == null:
		return
	
	# Start shooting for all combat states
	var shoot_timer = enemy.get_node_or_null("ShootTimer")
	if shoot_timer:
		shoot_timer.start()

func exit() -> void:
	if enemy == null:
		return
		
	# Stop shooting when leaving state
	var shoot_timer = enemy.get_node_or_null("ShootTimer")
	if shoot_timer:
		shoot_timer.stop()

func physics_update(delta: float) -> void:
	pass

func handle_sprite_flip(direction_vector: Vector2) -> void:
	if enemy == null or enemy.sprite == null:
		return
		
	if enemy.sprite is Sprite2D and direction_vector.x != 0:
		enemy.sprite.flip_h = (direction_vector.x < 0)
