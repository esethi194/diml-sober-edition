extends Node

signal task_completed(task_id)
signal task_started(task_id)
signal all_tasks_completed

var tasks: Array[Dictionary] = [
	{
		"id": 1,
		"title": "Stay Hydrated",
		"description": "Get water from the kitchen instead of indulging in alcohol. Click to interact, when near fridge!",
		"type": "interaction",
		"target": "fridge",
		"completed": false
	},
	{
		"id": 2, 
		"title": "Take a Breather",
		"description": "Step outside for fresh air and perspective. Go to the tree outside!",
		"type": "location_timer",
		"target": "tree",
		"timer_duration": 10,
		"completed": false
	},
	{
		"id": 3,
		"title": "Practice Mindfulness", 
		"description": "Find a quiet space for grounding exercises. Go to a bathroom!",
		"type": "location_timer",
		"target": "bathroom",
		"timer_duration": 10,
		"completed": false
	},
	{
		"id": 4,
		"title": "Make Your Exit",
		"description": "Time to leave this environment safely. Use the driveway to go home! Press ENTER when you're at the bottom of the driveway.",
		"type": "exit",
		"completed": false
	}
]

var current_task_index: int = 0
var task_timer: float = 0.0
var timer_active: bool = false


func _ready() -> void:
	start_current_task()


func _process(delta: float) -> void:
	if timer_active:
		task_timer -= delta
		if task_timer <= 0.0:
			complete_current_task()
	shortcuts()


# Always returns a Dictionary; {} means "no active task"
func get_current_task() -> Dictionary:
	if current_task_index >= 0 and current_task_index < tasks.size():
		return tasks[current_task_index]
	return {}


func start_current_task() -> void:
	var task: Dictionary = get_current_task()
	if task.is_empty():
		return
	emit_signal("task_started", task["id"])


func complete_current_task() -> void:
	var task: Dictionary = get_current_task()
	if task.is_empty():
		return
	if task.get("completed", false):
		return
	
	task["completed"] = true
	timer_active = false
	emit_signal("task_completed", task["id"])
	
	var score_manager = get_tree().get_first_node_in_group("score_manager")
	if score_manager:
		score_manager.addTask()
	
	await get_tree().create_timer(3.0).timeout
	
	current_task_index += 1
	
	if current_task_index >= tasks.size():
		emit_signal("all_tasks_completed")
	else:
		start_current_task()


func on_interaction(target_name: String) -> void:
	var task: Dictionary = get_current_task()
	if task.is_empty():
		return
	
	var task_type: String = task.get("type", "")
	var task_target: String = task.get("target", "")
	
	if task_type == "interaction" and task_target == target_name:
		complete_current_task()


func on_location_entered(location_name: String) -> void:
	var task: Dictionary = get_current_task()
	if task.is_empty():
		return
	
	var task_type: String = task.get("type", "")
	var task_target: String = task.get("target", "")
	
	if (task_type == "location_timer" or task_type == "location") and task_target == location_name:
		if task.has("timer_duration"):
			task_timer = float(task["timer_duration"])
			timer_active = true
		else:
			complete_current_task()


func on_location_exited(location_name: String) -> void:
	var task: Dictionary = get_current_task()
	if task.is_empty():
		return
	
	if task.has("target") and task["target"] == location_name and timer_active:
		timer_active = false


func restart_all_tasks() -> void:
	current_task_index = 0
	timer_active = false
	task_timer = 0.0
	
	for task in tasks:
		task["completed"] = false
	
	start_current_task()


func get_timer_remaining() -> float:
	if timer_active:
		return max(0.0, task_timer)
	return 0.0


func shortcuts() -> void:
	if Input.is_action_just_pressed("task"):
		complete_current_task()
