extends BulletBase

# Initialize player bullet properties
func _ready():
	add_to_group("player_bullet")
	damage = 10
	super._ready()
