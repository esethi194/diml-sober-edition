extends EnemyBase

const PatrolState = preload("res://enemyStates/states/patrol_state.gd")
const CircleState = preload("res://enemyStates/states/circle_state.gd")

func _ready() -> void:
	enemy_type = "druggie"
	sprite_variants = [
		preload("res://sprites/druggie/druggie_1.png"),
		preload("res://sprites/druggie/druggie_2.png"),
		preload("res://sprites/druggie/druggie_3.png"),
	]
	damage = 7
	bullet_scene = preload("res://enemyStates/druggie/druggie_bullet.tscn")
	patrol_speed = 30
	
	super._ready()
	
	state_machine.add_state(PatrolState.new())
	state_machine.add_state(CircleState.new())
	
	state_machine.change_state("patrol")
