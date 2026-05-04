extends BulletBase


func _ready():
	add_to_group("player_bullet")
	add_to_group("mirror_bullet")
	damage = 10
	super._ready()
	
