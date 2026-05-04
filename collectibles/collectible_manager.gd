extends Node2D

# Collectible scenes that can appear at marker spots.
var collectible_scenes = [
	preload("res://collectibles/collectibles_instances/card.tscn"),
	preload("res://collectibles/collectibles_instances/cube.tscn"),
	preload("res://collectibles/collectibles_instances/earbud.tscn")
]

var markers = []
var spawn_delay = 5
var active_collectibles = []
var marker_collectibles = {}

@onready var markers_node = get_node("markers")

func _ready():
	randomize()
	if markers_node == null:
		push_warning("CollectibleManager: markers node not found")
		return
	
	for child in markers_node.get_children():
		if child is Marker2D:
			markers.append(child)
	
	if markers.is_empty():
		push_warning("CollectibleManager: no marker nodes found")
	
	start_spawn_cycle.call_deferred()

func start_spawn_cycle():
	remove_all_collectibles()
	
	var shuffled_markers = markers.duplicate()
	shuffled_markers.shuffle()
	
	for marker in shuffled_markers:
		spawn_collectible_at_marker(marker)

func spawn_collectible_at_marker(marker):
	if marker_collectibles.has(marker) and is_instance_valid(marker_collectibles[marker]):
		return
	
	var random_index = randi() % collectible_scenes.size()
	var collectible_scene = collectible_scenes[random_index]
	
	var collectible = collectible_scene.instantiate()
	
	if !collectible.has_signal("collected"):
		collectible.add_user_signal("collected")
	
	collectible.collected.connect(_on_collectible_collected.bind(marker, collectible))
	
	active_collectibles.append(collectible)
	marker_collectibles[marker] = collectible
	
	var spawn_parent = get_parent()
	if spawn_parent == null:
		spawn_parent = self
	
	spawn_parent.add_child(collectible)
	collectible.global_position = marker.global_position

func remove_all_collectibles():
	for collectible in active_collectibles:
		if collectible and is_instance_valid(collectible):
			collectible.queue_free()
	
	active_collectibles.clear()
	marker_collectibles.clear()

func _on_collectible_collected(marker, collectible):
	active_collectibles.erase(collectible)
	marker_collectibles.erase(marker)
	
	if collectible and is_instance_valid(collectible):
		collectible.queue_free()
	
	var timer = get_tree().create_timer(spawn_delay)
	timer.timeout.connect(spawn_collectible_at_marker.bind(marker))
