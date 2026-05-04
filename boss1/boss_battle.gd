extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var spawner = $CanvasLayer/miniBossManager
	var boss = $CanvasLayer/boss
	if spawner and boss:
		spawner.end_of_mini_boss_spawn.connect(boss._on_end_of_mini_boss_spawn)
	MusicManager.play_boss()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	shortcuts()  
	
func shortcuts() -> void:
	if Input.is_action_just_pressed("next"):
		get_tree().change_scene_to_file("res://sprites/ui/relapse/relapse_UI.tscn")
	elif Input.is_action_just_pressed("back"):
		get_tree().change_scene_to_file("res://boss1/boss_room.tscn")
	elif Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene() 
	elif Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("pause"):
		$pauseMenu.visible = true
	elif Input.is_action_just_pressed("relapse"):
		get_tree().change_scene_to_file("res://sprites/ui/relapse/relapse_UI.tscn")
	elif Input.is_action_just_pressed("timeout"):
		get_tree().change_scene_to_file("res://sprites/ui/relapse/timeout_UI.tscn")
	elif Input.is_action_just_pressed("win"):
		get_tree().change_scene_to_file("res://win.tscn")
