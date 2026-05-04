extends Node2D

# Add bullet to appropriate container based on enemy type
func add_bullet(enemy_type: String, bullet: Node2D):
	match enemy_type:
		"druggie":
			$DruggieContainer.add_child(bullet)
		"meany":
			$MeanyContainer.add_child(bullet)
		"jock":
			$JockContainer.add_child(bullet)
		"miniBoss":
			$MiniBossContainer.add_child(bullet)
		"boss":
			$BossContainer.add_child(bullet)
