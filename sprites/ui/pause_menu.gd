extends CanvasLayer

func _ready() -> void:
	# Hide menu at start
	visible = false
	# Make sure this node runs even when the tree is paused
	process_mode = Node.PROCESS_MODE_ALWAYS

func resume() -> void:
	get_tree().paused = false
	visible = false

func pause() -> void:
	get_tree().paused = true
	visible = true

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused:
			resume()
		else:
			pause()

func _on_continue_pressed() -> void:
	resume()

func _on_controls_pressed() -> void:
	resume()  # optional: unpause before leaving
	get_tree().change_scene_to_file("res://sprites/ui/controls.tscn")

func _on_main_menu_pressed() -> void:
	resume()  # make sure you don’t leave the tree paused
	get_tree().change_scene_to_file("res://main/main.tscn")
