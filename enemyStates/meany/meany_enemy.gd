extends EnemyBase

const PatrolState = preload("res://enemyStates/states/patrol_state.gd")
const StareState = preload("res://enemyStates/states/stare_state.gd")
const ChaseState = preload("res://enemyStates/states/chase_state.gd")

func _ready() -> void:
	enemy_type = "meany"
	sprite_variants = [
		preload("res://sprites/meany/meangirl_1.png"),
		preload("res://sprites/meany/meangirl_2.png"),
		preload("res://sprites/meany/meangirl_3.png"),
		preload("res://sprites/meany/meangirl_4.png"),
		preload("res://sprites/meany/meangirl_5.png"),
	]
	damage = 4
	bullet_scene = preload("res://enemyStates/meany/meany_bullet.tscn")
	
	super._ready()
	
	state_machine.add_state(PatrolState.new())
	state_machine.add_state(StareState.new())
	state_machine.add_state(ChaseState.new())
	
	state_machine.change_state("patrol")
	
