extends Control

func _ready() -> void:
	MusicManager.play_main_invite()
	
# Handle input shortcuts
func _process(_delta: float) -> void:
	shortcuts()

# Handle keyboard shortcuts
func shortcuts() -> void:
	if Input.is_action_just_pressed("next"):
		get_tree().change_scene_to_file("res://level 1/invite.tscn")
	elif Input.is_action_just_pressed("back"):
		get_tree().change_scene_to_file("res://main/main.tscn")
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
	
# Handle settings button press
func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://sprites/ui/controls.tscn")

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://level 1/invite.tscn")
	
func _on_exit_pressed() -> void:
	get_tree().quit()
