class_name Player
extends CharacterBody2D

var sobrietyManager: SobrietyManagerBase = null
var is_shooting: bool = false
var can_shoot: bool = true
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
var last_facing := 1 # 1 = right, -1 = left
var hit_feedback_tween: Tween
var can_take_damage := true

@export var BULLET_SCENE: PackedScene
@export var SPEED: float = 800
@export var shoot_cooldown: float = 0.2
@export var damage_cooldown: float = 0.75

const MAP_LEFT = 485
const MAP_TOP = -225
const MAP_RIGHT = 6800
const MAP_BOTTOM = 4350

func _ready():
	add_to_group("player")
	BULLET_SCENE = preload("res://player/player_bullet.tscn")
	var sobriety_managers = get_tree().get_nodes_in_group("sobriety_manager")
	if sobriety_managers.size() > 0:
		sobrietyManager = sobriety_managers[0]
			
func _physics_process(delta: float) -> void:
	if not is_shooting:
		var input_dir = Input.get_vector("left", "right", "up", "down")
		velocity = input_dir * SPEED
		var is_moving := input_dir.length() > 0.0

		if is_moving:
			# update facing
			if input_dir.x < 0:
				last_facing = -1
				anim.play("walk_left")
			elif input_dir.x > 0:
				last_facing = 1
				anim.play("walk_right")
			else:
				# moving only up/down → use last facing
				if last_facing < 0:
					anim.play("walk_left")
				else:
					anim.play("walk_right")
		else:
			# not moving → idle anim in last facing direction
			if last_facing < 0:
				anim.play("idle_left")
			else:
				anim.play("idle_right")

		move_and_slide()
	else:
		# while shooting, stop moving (or keep whatever you want here)
		velocity = Vector2.ZERO
		if last_facing < 0:
			anim.play("idle_left")
		else:
			anim.play("idle_right")
	
	global_position.x = clamp(global_position.x, MAP_LEFT, MAP_RIGHT)
	global_position.y = clamp(global_position.y, MAP_TOP, MAP_BOTTOM)
	
	if Input.is_action_just_released("shoot") and can_shoot:
		shoot()

func shoot() -> void:
	is_shooting = true
	can_shoot = false
	
	var bullet := BULLET_SCENE.instantiate()
	var direction = (get_global_mouse_position() - global_position).normalized()
	
	if direction == Vector2.ZERO:
		direction.x = -1.0 if $AnimatedSprite2D.flip_h else 1.0
	
	bullet.position = position + direction * 16
	bullet.direction_x = direction.x
	bullet.direction_y = direction.y
	get_parent().add_child(bullet)
	
	await get_tree().create_timer(0.1).timeout
	is_shooting = false
	
	if BULLET_SCENE.resource_path.contains("mirror"):
		shoot_cooldown = 1.0
	get_tree().create_timer(shoot_cooldown).timeout.connect(_on_shoot_cooldown_finished)

func _on_shoot_cooldown_finished():
	can_shoot = true

func takeDamage(amount: int) -> void:
	if not can_take_damage:
		return
	
	can_take_damage = false
	if sobrietyManager:
		sobrietyManager.takeDamage(amount)
	show_hit_feedback()
	get_tree().create_timer(damage_cooldown).timeout.connect(_on_damage_cooldown_finished)

func show_hit_feedback() -> void:
	if hit_feedback_tween:
		hit_feedback_tween.kill()
	
	anim.modulate = Color(1, 0.2, 0.2)
	hit_feedback_tween = create_tween()
	hit_feedback_tween.tween_property(anim, "modulate", Color.WHITE, 0.5)

func _on_damage_cooldown_finished() -> void:
	can_take_damage = true

func takeHealth(amount: int) -> void:
	if sobrietyManager:
		sobrietyManager.takeHealth(amount)

func triggerLevelUp():
	if sobrietyManager:
		sobrietyManager.levelUp()

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		var damage = body.damage if "damage" in body else 10
		takeDamage(damage)
		
func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy_bullet"):
		takeDamage(3)
		area.call_deferred("queue_free")
			
