extends Area2D

# Handle area collision with enemies and bullets
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		get_parent().takeDamage(5)
	
	if area.is_in_group("enemy_bullet"):
		get_parent().takeDamage(5)
