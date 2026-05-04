extends Node
class_name BossTaskManager

signal task_completed(task_id)
signal task_started(task_id)
signal all_tasks_completed

var tasks: Array[Dictionary] = [
	{
		"id": 1,
		"title": "Survive the Waves",
		"description": "Stay alive while mini-enemies spawn and attack you.",
		"type": "timer",
		"timer_duration": 30,
		"completed": false
	},
	{
		"id": 2,
		"title": "Collect the Mirror",
		"description": "When the shard appears, reach it and interact to pick it up.",
		"type": "interaction",
		"target": "mirror",
		"completed": false
	},
	{
		"id": 3,
		"title": "Face the Monster",
		"description": "Use the mirror shard to finish the boss.",
		"type": "interaction",
		"target": "boss",
		"completed": false
	},
	{
		"id": 4,
		"title": "Get the Sobriety Chip",
		"description": "Go and collect the sobriety chip.",
		"type": "interaction",
		"target": "coin",
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


func get_current_task() -> Dictionary:
	if current_task_index >= 0 and current_task_index < tasks.size():
		return tasks[current_task_index]
	return {}


func start_current_task() -> void:
	var task: Dictionary = get_current_task()
	if task.is_empty():
		return
	
	emit_signal("task_started", task["id"])
	
	if task.has("timer_duration"):
		task_timer = float(task["timer_duration"])
		timer_active = true


func complete_current_task() -> void:
	var task: Dictionary = get_current_task()
	if task.is_empty():
		return
	if task.get("completed", false):
		return
	
	task["completed"] = true
	timer_active = false
	emit_signal("task_completed", task["id"])
	
	await get_tree().create_timer(2.0).timeout
	
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


func get_timer_remaining() -> float:
	if timer_active:
		return max(0.0, task_timer)
	return 0.0
