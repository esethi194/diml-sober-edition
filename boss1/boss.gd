extends EnemyBase
class_name Boss

var original_scale: Vector2
var current_scale: float = 1.0
var coinScene = preload("res://collectibles/collectibles_instances/coin.tscn")


func _ready():
	super._ready()
	original_scale = scale 
	enemy_type = "boss"
	shoot_cooldown = 1
	bullet_scene = preload("res://boss1/boss_bullet.tscn")

func _physics_process(delta):
	velocity = Vector2.ZERO  # Lock velocity to zero
	position = start_position  # Lock position

func take_damage():
	pass  # Boss immune to bullets

func apply_knockback(from_position: Vector2, strength: float = 20.0) -> void:
	pass  # No knockback

func shrink():
	if current_scale > 0.3:
		current_scale -= 0.07
		scale = original_scale * current_scale
	else:
		call_deferred("change_sprite")

func change_sprite():
	var coin = coinScene.instantiate()
	get_parent().add_child(coin)
	coin.global_position = global_position
	boss_task_manager.on_interaction("boss")
	queue_free()	
	
func _on_end_of_mini_boss_spawn():
	active = true 
