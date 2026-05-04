extends Control

@export var manager_autoload_name: String = ""

@onready var title = $VBoxContainer/Title
@onready var description = $VBoxContainer/Description
@onready var timer = $VBoxContainer/Timer
@onready var checkmark = $VBoxContainer/Checkmark
@onready var completion_sound = $CompletionSound

var manager: Node = null

func _ready():
	add_to_group("sidebar_ui")
	
	# Grab the manager from /root (autoload)
	if Engine.is_editor_hint():
		return
	
	if has_node("/root/" + manager_autoload_name):
		manager = get_node("/root/" + manager_autoload_name)
	else:
		push_error("SidebarUI: Could not find autoload '%s'" % manager_autoload_name)
		return
	
	# Connect to manager signals
	if manager.has_signal("task_started"):
		manager.task_started.connect(_on_task_started)
	if manager.has_signal("task_completed"):
		manager.task_completed.connect(_on_task_completed)
	
	# Hide completion elements initially
	checkmark.visible = false
	timer.visible = false
	
	update_task_display()

func _process(delta):
	if manager == null:
		return
	
	var timer_remaining = manager.get_timer_remaining()
	if timer_remaining > 0:
		timer.visible = true
		timer.text = "Time: " + str(int(timer_remaining + 1)) + "s"
	else:
		timer.visible = false

func _on_task_started(task_id: int):
	update_task_display()

func _on_task_completed(task_id: int):
	checkmark.visible = true
	checkmark.text = "✓ Complete!"
	if completion_sound:
		completion_sound.play()

func update_task_display():
	if manager == null:
		return
	
	var current_task = manager.get_current_task()
	if current_task.is_empty():
		title.text = ""
		description.text = ""
		checkmark.visible = false
		return
	
	title.text = str(current_task.get("title", ""))
	description.text = str(current_task.get("description", ""))
	checkmark.visible = false
