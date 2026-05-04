extends CharacterBody2D
class_name EnemyBase

@export var sprite_variants: Array[Texture2D] = []
@export var bullet_scene: PackedScene
@export var patrol_distance: float = 75
@export var patrol_speed: float = 50
@export var chase_speed: float = 75
@export var shoot_cooldown: float = 3

@onready var sprite = $enemySprite
@onready var state_machine = $StateMachine

var damage := 0
var start_position: Vector2
var patrol_direction := 1
var player : Node2D
var enemy_type: String
var active := false
var hit_flash_tween: Tween
var default_sprite_modulate := Color.WHITE

func _ready():
	start_position = global_position
	randomize_sprite()
	default_sprite_modulate = sprite.modulate
	player = get_tree().get_first_node_in_group("player") as Node2D
	
	var timer = $ShootTimer
	timer.wait_time = shoot_cooldown
	timer.timeout.connect(_on_shoot_timer_timeout)
	timer.one_shot = false
	timer.start()
	
	add_to_group("enemies")

func _physics_process(delta):
	if state_machine:
		state_machine.physics_update(delta)

func activate():
	if active: return
	active = true
	if state_machine:
		state_machine.change_state("patrol")
	
func deactivate():
	if not active: return
	active = false
	if state_machine:
		state_machine.change_state("patrol")

func randomize_sprite():
	if sprite_variants and not sprite_variants.is_empty() and sprite is Sprite2D:
		var chosen = sprite_variants.pick_random()
		sprite.texture = chosen

func shoot():
	if bullet_scene == null:
		return
	if player == null:
		player = get_tree().get_first_node_in_group("player") as Node2D
		if player == null:
			return

	var bullet = bullet_scene.instantiate()
	var dir_vector = (player.global_position - global_position).normalized()
	
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = global_position
	if bullet.has_method("set_direction"):
		bullet.set_direction(dir_vector)
	else:
		bullet.direction_x = dir_vector.x
		bullet.direction_y = dir_vector.y

func _on_shoot_timer_timeout() -> void:
	if active:
		shoot()

func apply_knockback(from_position: Vector2, strength: float = 20.0) -> void:
	var dx = global_position.x - from_position.x
	var dy = global_position.y - from_position.y

	var knock_x = strength if dx > 0 else -strength
	var knock_y = strength if dy > 0 else -strength

	global_position.x += knock_x
	global_position.y += knock_y

func show_hit_flash() -> void:
	if hit_flash_tween:
		hit_flash_tween.kill()
	
	sprite.modulate = Color(2.0, 2.0, 2.0)
	hit_flash_tween = create_tween()
	hit_flash_tween.tween_property(sprite, "modulate", default_sprite_modulate, 0.2)
