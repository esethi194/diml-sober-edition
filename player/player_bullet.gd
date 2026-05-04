extends BulletBase

func _ready():
	add_to_group("player_bullet")
	super._ready()

func _physics_process(delta: float):
	# Move the bullet
	position.x += direction_x * speed * delta
	position.y += direction_y * speed * delta
