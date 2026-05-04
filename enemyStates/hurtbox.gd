extends Area2D

# Handle area collision with player bullets
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("mirror_bullet"):
		get_parent().shrink()
		area.queue_free()
	if area.is_in_group("player_bullet"):
		var enemy = get_parent()
		if enemy.has_method("show_hit_flash"):
			enemy.show_hit_flash()
		enemy.apply_knockback(area.global_position, 30.0)
		area.queue_free()
		
