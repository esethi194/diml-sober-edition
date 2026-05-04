extends Area2D

@export var sprite_img1: Texture2D
@export var sprite_img2: Texture2D

@onready var sprite: Sprite2D = $Sprite

func _ready() -> void:
	sprite.texture = sprite_img1
	input_pickable = true
	
func _process(delta: float) -> void:
	pass

# Handle mouse clicks on the Area2D itself
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		_toggle_sprite()

func _toggle_sprite() -> void:
	sprite.texture = sprite_img2
	
	task_manager.on_interaction("fridge")
			
	self.queue_free()
