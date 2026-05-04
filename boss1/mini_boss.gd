extends CharacterBody2D

# === EXPORTED VARIABLES ===
@export var sprite_variants: Array[Texture2D] = []
@export var patrol_distance: float = 75
@export var patrol_speed: float = 50
@export var chase_speed: float = 80
@export var shoot_cooldown: float = 3
@export var follow_distance: float = 450
@export var bullet_scene: PackedScene

# === NODE REFERENCES ===
@onready var sprite = $enemySprite

# === STATE VARIABLES ===
var health := 100
var shoot_direction
var start_position: Vector2
var patrol_direction := 1
var shoot_timer := 0.0
var player_in_range := true
var player = null
var damage_multiplier := 1.0
var direction := 0.0

# === READY ===
func _ready():
	# Store the initial position for patrol behavior
	start_position = global_position
	randomize_sprite()

	# Get player node from group
	player = get_tree().get_first_node_in_group("player")

	# Preload bullet scene (in case not set via Inspector)
	if bullet_scene == null:
		bullet_scene = preload("res://boss1/mini_boss_bullet.tscn")

	# Create and configure shooting timer
	var timer = Timer.new()
	timer.name = "ShootTimer"
	timer.wait_time = shoot_cooldown
	timer.one_shot = false
	timer.autostart = true
	timer.timeout.connect(_on_shoot_timer_timeout)
	add_child(timer)

# === PHYSICS PROCESS ===
func _physics_process(delta):
	if player == null:
		player = get_tree().get_first_node_in_group("player")
		if player == null:
			patrol(delta)  # Patrol if no player found
			return
	check_player(delta)
	
# === PLAYER DETECTION LOGIC ===
func check_player(delta):
	if player_in_range:
		follow_player_and_shoot(delta)
	else:
		patrol(delta)

# === PATROL BEHAVIOR ===
func patrol(delta):
	var target_x = start_position.x + patrol_distance * patrol_direction
	direction = sign(target_x - global_position.x)
	global_position.x += direction * patrol_speed * delta
	global_position.y = start_position.y

	# Flip sprite based on direction
	if sprite is Sprite2D:
		sprite.flip_h = (direction < 0)

	# Change direction if near patrol endpoint
	if abs(global_position.x - target_x) < 5:
		patrol_direction *= -1

# === FOLLOW PLAYER ===
func follow(delta):
	if player == null:
		return
	var dir_vector = (player.global_position - global_position).normalized()
	global_position += dir_vector * chase_speed * delta
	move_and_slide()

	if sprite is Sprite2D:
		sprite.flip_h = (dir_vector.x < 0)

# === RANDOMIZE SPRITE VARIANT ===
func randomize_sprite():
	if sprite_variants and not sprite_variants.is_empty() and sprite is Sprite2D:
		sprite.texture = sprite_variants.pick_random()

# === DAMAGE HANDLING ===
func take_damage(amount: int):
	health -= amount * damage_multiplier
	if health <= 0:
		queue_free()

# === FOLLOW & SHOOT WRAPPER ===
func follow_player_and_shoot(delta):
	follow(delta)
	# Shooting handled by timer (_on_shoot_timer_timeout)

# === SHOOTING BULLET ===
func shoot():
	if bullet_scene == null:
		push_error(name + ": Cannot shoot - bullet_scene is null")
		return
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

# === DETECTION SIGNALS ===
func _on_detection_area_body_entered(body):
	if body.is_in_group("player"):
		player = body
		player_in_range = true

func _on_detection_area_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false

# === TIMER SIGNAL ===
func _on_shoot_timer_timeout():
	shoot()
