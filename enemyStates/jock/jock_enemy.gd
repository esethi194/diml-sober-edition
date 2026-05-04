extends EnemyBase

const PatrolState = preload("res://enemyStates/states/patrol_state.gd")
const ChaseState = preload("res://enemyStates/states/chase_state.gd")

func _ready() -> void:
	enemy_type = "jock"
	sprite_variants = [
		preload("res://sprites/Jocks/jock_1.png"),
		preload("res://sprites/Jocks/jock_2.png"),
		preload("res://sprites/Jocks/jock_3.png"),
	]
	damage = 2
	bullet_scene = preload("res://enemyStates/jock/jock_bullet.tscn")
	chase_speed = 120
	
	super._ready()
	
	state_machine.add_state(PatrolState.new())
	state_machine.add_state(ChaseState.new())
	
	state_machine.change_state("patrol")
