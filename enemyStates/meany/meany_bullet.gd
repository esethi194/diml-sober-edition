extends BulletBase

# Initialize meany bullet properties
func _ready():
	add_to_group("enemy_bullet")
	damage = 6
	speed = speed * 0.75
	super._ready()
