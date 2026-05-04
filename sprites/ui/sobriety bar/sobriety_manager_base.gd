# sobriety_manager_base.gd
class_name SobrietyManagerBase
extends TextureProgressBar

signal sobrietyChanged
signal relapsed

@onready var player: Player = null
var baseSobriety: int = 100
var maxSobriety: int
var currentSobriety: int
var relapse_started := false
const GAME_OVER_DELAY := 1.0

func _ready() -> void:
	add_to_group("sobriety_manager")
	maxSobriety = baseSobriety
	currentSobriety = maxSobriety
	await get_tree().process_frame
	find_player()
	update_bar()

func find_player() -> void:
	if has_node("Player"):
		player = get_node("Player")
	else:
		var players = get_tree().get_nodes_in_group("player")
		if players.size() > 0:
			player = players[0]
	
	if not player:
		push_error("Player node not found!")

func update_bar() -> void:
	if currentSobriety > 0:
		value = currentSobriety * 100.0 / maxSobriety
	else:
		value = 0
	emit_signal("sobrietyChanged")

func takeDamage(amount: int) -> void:
	if relapse_started:
		return
	
	currentSobriety = max(0, currentSobriety - amount)
	update_bar()
	if currentSobriety <= 0:
		handleRelapse()

func takeHealth(amount: int) -> void:
	currentSobriety = min(currentSobriety + amount, maxSobriety)
	update_bar()

func handleRelapse() -> void:
	if relapse_started:
		return
	relapse_started = true
	
	emit_signal("relapsed")
	task_manager.restart_all_tasks()
	await get_tree().create_timer(GAME_OVER_DELAY).timeout
	get_tree().change_scene_to_file("res://sprites/ui/relapse/relapse_UI.tscn")

func getSobrietyPercentage() -> float:
	if maxSobriety > 0:
		return float(currentSobriety) / float(maxSobriety)
	return 0.0
