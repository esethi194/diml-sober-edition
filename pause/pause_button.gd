extends TextureButton
	
@onready var pauseMenu = get_parent().get_node("pauseMenu")

func _on_pressed() -> void:
	pauseMenu.pause()
