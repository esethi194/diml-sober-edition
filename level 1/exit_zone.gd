extends Area2D

var player_nearby := false
var exit_available := false

func _ready() -> void:
	exit_available = false
	task_manager.task_started.connect(_on_task_started)

func _process(delta: float) -> void:
	if player_nearby and exit_available and Input.is_action_just_pressed("exit"):
		if task_manager.get_current_task().get("id", 0) == 4:
			task_manager.complete_current_task()
		get_tree().change_scene_to_file("res://boss1/boss_room.tscn")

func _on_player_enter(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_nearby = true

func _on_player_exit(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_nearby = false

func _on_task_started(task_id: int) -> void:
	if task_id == 4:
		exit_available = true
