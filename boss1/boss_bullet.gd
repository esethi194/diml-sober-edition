extends BulletBase

func _ready():
	add_to_group("enemy_bullet")
	damage = 7
	super._ready()
