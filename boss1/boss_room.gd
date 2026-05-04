extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	shortcuts()  

func shortcuts() -> void:
	if Input.is_action_just_pressed("next"):
		get_tree().change_scene_to_file("res://boss1/boss_battle.tscn")
	elif Input.is_action_just_pressed("back"):
		get_tree().change_scene_to_file("res://level 1/world_1_level_v1.tscn")
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


func _on_trigger_body_entered(body: Node2D):
	if body.is_in_group("player"):
		get_tree().call_deferred("change_scene_to_file","res://boss1/boss_battle.tscn")
