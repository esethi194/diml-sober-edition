extends BulletBase

# Initialize jock bullet properties
func _ready():
	add_to_group("enemy_bullet")
	damage = 6
	super._ready()
