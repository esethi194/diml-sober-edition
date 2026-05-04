extends interactable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _toggle_sprite() -> void:
	if using_alt_sprite:
		sprite.texture = sprite_img1
		sprite.z_index = 1 
	else:
		sprite.texture = sprite_img2
		sprite.z_index = -1 
	using_alt_sprite = !using_alt_sprite
