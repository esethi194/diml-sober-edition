extends BulletBase

# Initialize druggie bullet properties
func _ready():
	add_to_group("enemy_bullet")
	damage = 6
	super._ready()
