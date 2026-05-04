extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#MusicManager.play_lose_timeout()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	shortcuts()  

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://level 1/invite.tscn")


func shortcuts() -> void:
	if Input.is_action_just_pressed("next"):
		get_tree().change_scene_to_file("res://level 1/invite.tscn")
	elif Input.is_action_just_pressed("back"):
		get_tree().change_scene_to_file("res://main/main.tscn")
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
