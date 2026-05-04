class_name StateMachine
extends Node

var current_state;
var states: Dictionary = {}
var is_ready := false
var enemy;
var pending_state_name := ""

func _ready() -> void:	
	# Get the enemy reference immediately
	enemy = get_parent() as EnemyBase
	
	if enemy == null:
		push_error("[StateMachine] Parent is not an EnemyBase!")
		return
		
	# Initialize all child states
	for child in get_children():
		if child is EnemyState:
			child.enemy = enemy
			child.state_machine = self
			states[child.name.to_lower()] = child	
	# Wait one frame for enemy to fully initialize
	await get_tree().process_frame
	
	is_ready = true
	
	if pending_state_name != "":
		var state_to_apply := pending_state_name
		pending_state_name = ""
		change_state(state_to_apply)
		return
	
	# Start with patrol state if it exists
	if states.has("patrol"):
		change_state("patrol")

func add_state(state: EnemyState, state_name: String = "") -> void:
	if enemy == null:
		push_error("[StateMachine] Cannot add state - enemy is null")
		return
	
	var key = ""
	if state_name != "":
		key = state_name.to_lower()
	elif state.name != "":
		key = state.name.to_lower()
	else:
		var script = state.get_script()
		if script:
			var class_name_str = script.get_global_name()
			if class_name_str != "":
				key = class_name_str.replace("State", "").to_lower()
	
	if key == "":
		push_error("[StateMachine] Could not determine state name for state")
		return
		
	state.enemy = enemy
	state.state_machine = self
	states[key] = state
	add_child(state)
	
func change_state(state_name: String) -> void:
	if not is_ready:
		if state_name.to_lower() == "patrol" and pending_state_name != "":
			return
		pending_state_name = state_name
		return
	
	var new_state = states.get(state_name.to_lower())
	
	if new_state == null:
		push_error("[StateMachine] State not found: " + state_name)
		return
		
	if current_state:
		current_state.exit()
	
	current_state = new_state
	current_state.enter()

func physics_update(delta: float) -> void:
	if current_state and is_ready:
		current_state.physics_update(delta)
