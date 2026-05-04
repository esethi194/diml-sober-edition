extends Node

@onready var scoreLabel: Label = $ScoreLabel

signal scoreChanged

var currentScore: int = 10
var highScore: int = 0
var survivalTime: float = 0.0
var timeScore: int = 0  # Track time points separately
var lastTimePoint: int = 0  # Track when we last gave time points

# Point values
var timePoints: int = 1       # Points per second
var collectiblePoints: int = 10
var taskPoints: int = 250


func _ready():
	add_to_group("score_manager")  # Add to group so collectibles can find it
	
	resetScore()
	
	scoreChanged.connect(updateScore)
	updateScore()
	

func updateScore():
	if scoreLabel:
		scoreLabel.text = "Score: " + str(currentScore)

func _process(delta):
	survivalTime += delta
	# Time-based scoring - give 1 point per second
	var currentSecond = int(survivalTime)
	if currentSecond > lastTimePoint:
		lastTimePoint = currentSecond
		timeScore += timePoints
		addScore(timePoints)

# Add score
func addScore(points: int):
	currentScore += points
	emit_signal("scoreChanged")
	
	if currentScore > highScore:
		highScore = currentScore

# Specific scoring functions
func addCollectible(points: int = collectiblePoints):
	addScore(points)
	updateScore()

func addTask(points: int = taskPoints):
	addScore(points)
	updateScore()

func resetScore():
	currentScore = 0
	timeScore = 0
	lastTimePoint = 0
	survivalTime = 0.0
	emit_signal("scoreChanged")
