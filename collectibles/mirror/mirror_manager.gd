extends Node2D

var collectible_scene = preload("res://collectibles/mirror/mirror.tscn")
@onready var marker = $mirror_marker

func _ready():
	self.visible = false
	if marker == null:
		return
	var mini_boss_manager = get_parent().get_node("miniBossManager") 
	if mini_boss_manager:
		mini_boss_manager.end_of_mini_boss_spawn.connect(_on_end_of_mini_boss_spawn)

func _on_end_of_mini_boss_spawn():
	spawn_collectible_at_marker(marker)

func spawn_collectible_at_marker(spawn_marker):
	var collectible = collectible_scene.instantiate()
	collectible.z_index = 10
	
	# Add to parent scene instead of invisible spawner
	get_parent().add_child(collectible)
	collectible.global_position = spawn_marker.global_position
