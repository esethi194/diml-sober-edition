extends Area2D

var hit_counter = 0;
# Handle area collision with player bullets
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_bullet"):
		hit_counter += 1
		area.queue_free()
		if hit_counter >= 6:
			get_parent().queue_free()
