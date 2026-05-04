extends Node2D

@warning_ignore("unused_signal")
signal end_of_mini_boss_spawn

@export var mini_boss_scene : PackedScene
var has_spawned = false
var current_spawn_index = 0
var spawn_count = 0
var max_spawns =5

func _ready():
	if mini_boss_scene == null:
		return
	get_tree().create_timer(0.5).timeout.connect(spawn_mini_boss)
	
func spawn_mini_boss():
	if spawn_count >= max_spawns:
		emit_signal("end_of_mini_boss_spawn")
		return
	spawn_enemies("mini_boss_marker", mini_boss_scene)
	spawn_count += 1
	get_tree().create_timer(5.0).timeout.connect(spawn_mini_boss)

func spawn_enemies(spawn_group_name: String, enemy_scene: PackedScene) -> bool:
	if enemy_scene == null:
		return false
	
	var spawn_points := get_tree().get_nodes_in_group(spawn_group_name)
	if spawn_points.is_empty():
		return false
	
	var spawn_marker = spawn_points[current_spawn_index]
	if spawn_marker is Marker2D:
		var enemy = enemy_scene.instantiate()
		enemy.global_position = spawn_marker.global_position
		add_child(enemy)
	
	current_spawn_index = (current_spawn_index + 1) % spawn_points.size()
	
	has_spawned = true
	return has_spawned
