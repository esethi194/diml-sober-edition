extends Node2D

@export var druggie_scene: PackedScene
@export var meany_scene: PackedScene
@export var jock_scene: PackedScene

var has_spawned := false

# Map marker-group -> enemy room group  (standardize spellings!)
const ROOM_GROUP_BY_MARKER_GROUP := {
	"kitchen_markers": "kitchen",
	"dining_marker":  "dining",   
	"pool_markers":    "pool",
	"living_markers":  "living",
	"dumpster_marker":"dumpster",
	"tree_marker":"tree",
}

func _ready():
	if has_spawned: return

	# Spawn each enemy type at their markers
	_spawn_enemies_for_group("jock_spawn",   jock_scene,   "jock")
	_spawn_enemies_for_group("meany_spawn",  meany_scene,  "meany")
	_spawn_enemies_for_group("druggie_spawn",druggie_scene,"druggie")

	has_spawned = true

# Spawn enemies at all markers in the spawn group, tag them with type + room groups
func _spawn_enemies_for_group(spawn_group_name: String, enemy_scene: PackedScene, type_group: String) -> void:
	if enemy_scene == null:
		push_warning("No enemy scene for spawn group: " + spawn_group_name)
		return

	var markers := get_tree().get_nodes_in_group(spawn_group_name)
	if markers.is_empty():
		return

	for marker in markers:
		if marker is Marker2D:
			if not marker.is_visible_in_tree():
				continue

			var enemy := enemy_scene.instantiate()

			# base/type groups
			enemy.add_to_group("enemies")
			enemy.add_to_group(type_group)   # e.g. "mean_girl", "jock", "druggie"
			if "enemy_type" in enemy:
				enemy.enemy_type = type_group

			# room group from marker’s room-* group(s)
			var room_group := _room_from_marker(marker)
			if room_group != "":
				enemy.add_to_group(room_group)
			else:
				push_warning("Marker %s has no *_markers room group" % marker.name)

			add_child(enemy)
			enemy.global_position = marker.global_position
			if "start_position" in enemy:
				enemy.start_position = enemy.global_position

func _room_from_marker(marker: Node) -> String:
	for k in ROOM_GROUP_BY_MARKER_GROUP.keys():
		if marker.is_in_group(k):
			return ROOM_GROUP_BY_MARKER_GROUP[k]
	return ""
