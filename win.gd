extends Control

func _ready() -> void:
	MusicManager.play_win()
	
# Handle input shortcuts
func _process(_delta: float) -> void:
	shortcuts()

# Handle keyboard shortcuts
func shortcuts() -> void:
	if Input.is_action_just_pressed("next"):
		get_tree().change_scene_to_file("res://main/main.tscn")
	elif Input.is_action_just_pressed("back"):
		get_tree().change_scene_to_file("res://main/main.tscn")
	elif Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene() 
	elif Input.is_action_just_pressed("quit"):
		get_tree().quit()

# Handle settings button press
func _on_continue_pressed() -> void:
	get_tree().change_scene_to_file("res://main/main.tscn")
