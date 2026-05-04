extends Area2D
class_name interactable

@export var sprite_img1: Texture2D
@export var sprite_img2: Texture2D

var player_in_range: bool = false
var using_alt_sprite: bool = false

@onready var sprite: Sprite2D = $Sprite

func _ready() -> void:
	sprite.texture = sprite_img1
	input_pickable = true

func _on_body_entered(body: Node):
	if body.is_in_group("player"):
		player_in_range = true

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player_in_range = false

func _process(delta: float) -> void:
	# Check enter key every frame
	if Input.is_action_just_pressed("enter"):
		if player_in_range:
			_toggle_sprite()

# Handle mouse clicks on the Area2D itself
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	# Only allow clicking when player is in range
	if not player_in_range:
		return
		
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_toggle_sprite()

func _toggle_sprite() -> void:
	if using_alt_sprite:
		sprite.texture = sprite_img1
	else:
		sprite.texture = sprite_img2
	using_alt_sprite = !using_alt_sprite
