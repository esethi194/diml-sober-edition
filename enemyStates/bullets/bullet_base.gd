extends Area2D
class_name BulletBase

@export var lifetime: float = 10.0
@export var damage: int = 5

var direction_x: float = 0.0
var direction_y: float = 0.0
var timer: Timer
var speed: float = 300.0

# Set bullet direction
func set_direction(direction_vector: Vector2):
	direction_x = direction_vector.x
	direction_y = direction_vector.y
	set_bullet_velocity()

# Initialize bullet
func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = lifetime
	timer.one_shot = true
	timer.timeout.connect(_on_lifetime_timeout)
	timer.start()
	set_bullet_velocity()

# Update bullet movement
func _process(delta: float) -> void:
	position += Vector2(direction_x, direction_y) * speed * delta

# Normalize direction vector
func set_bullet_velocity():
	var length = sqrt(direction_x * direction_x + direction_y * direction_y)
	if length > 0.0:
		direction_x /= length
		direction_y /= length

# Destroy bullet after lifetime
func _on_lifetime_timeout() -> void:
	queue_free()

# Clean up when child exits
func _on_child_exiting_tree(node: Node) -> void:
	queue_free()

# Handle collision with bodies
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		if body.has_method("takeDamage"):
			body.takeDamage(damage)
			queue_free()
	elif body.is_in_group("enemy"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
			queue_free()
	elif body.is_in_group("collider"):
		queue_free()
	elif body.is_in_group("wall"):
		queue_free()
	else:
		queue_free()
