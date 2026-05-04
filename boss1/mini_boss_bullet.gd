extends BulletBase


func _ready():
	add_to_group("enemy_bullet")
	damage = 10
	super._ready()
