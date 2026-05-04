extends Node2D

func _ready() -> void:
	MusicManager.play_level1()
	
# Handle input shortcuts
func _process(_delta: float) -> void:
	shortcuts()

# Handle keyboard shortcuts
func shortcuts() -> void:
	if Input.is_action_just_pressed("next"):
		get_tree().change_scene_to_file("res://boss1/boss_room.tscn")
	elif Input.is_action_just_pressed("back"):
		get_tree().change_scene_to_file("res://level 1/invite.tscn")
	elif Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene() 
	elif Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("relapse"):
		get_tree().change_scene_to_file("res://sprites/ui/relapse/relapse_UI.tscn")
	elif Input.is_action_just_pressed("timeout"):
		get_tree().change_scene_to_file("res://sprites/ui/relapse/timeout_UI.tscn")
	elif Input.is_action_just_pressed("win"):
		get_tree().change_scene_to_file("res://win.tscn")
