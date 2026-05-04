extends Node

@onready var audio_player: AudioStreamPlayer = $AudioPlayer

# 🎵 Update these to your actual file paths
const MAIN_INVITE_TRACK   := "res://sound/dawnofchange.mp3"
const LEVEL1_TRACK        := "res://sound/melancholylull.mp3"
const BOSS_TRACK          := "res://sound/epic.mp3"
const WIN_TRACK           := "res://sound/unbreakableresolve.mp3"
const LOSE_TIMEOUT_TRACK  := "res://sound/sleepless.mp3"

var DEFAULT_VOLUME_DB := -35.0
const MUTED_VOLUME_DB   := -70.0
const FADE_TIME         := 0.5

var _current_path: String = ""


func _ready() -> void:
	# Nothing by default; scenes decide what to play.
	pass


func set_music(stream_path: String) -> void:
	if stream_path == "":
		return

	# Don't restart if it's the same track and already playing
	if stream_path == _current_path and audio_player.playing:
		return

	var stream := load(stream_path) as AudioStream
	if stream == null:
		push_warning("MusicManager: Could not load stream at: " + stream_path)
		return

	_current_path = stream_path

	# If something is already playing, fade out then swap + fade in
	if audio_player.playing:
		var tween := create_tween()
		tween.tween_property(audio_player, "volume_db", MUTED_VOLUME_DB, FADE_TIME)
		tween.tween_callback(func ():
			audio_player.stream = stream
			audio_player.play()
			audio_player.volume_db = MUTED_VOLUME_DB
			var tween_in := create_tween()
			tween_in.tween_property(audio_player, "volume_db", DEFAULT_VOLUME_DB, FADE_TIME)
		)
	else:
		audio_player.stream = stream
		audio_player.volume_db = DEFAULT_VOLUME_DB
		audio_player.play()


func fade_out(time: float = FADE_TIME) -> void:
	var tween := create_tween()
	tween.tween_property(audio_player, "volume_db", MUTED_VOLUME_DB, time)


func fade_in(time: float = FADE_TIME, target_db: float = DEFAULT_VOLUME_DB) -> void:
	audio_player.volume_db = MUTED_VOLUME_DB
	var tween := create_tween()
	tween.tween_property(audio_player, "volume_db", target_db, time)


# 🎯 Helper functions for each part of the game

func play_main_invite() -> void:
	set_music(MAIN_INVITE_TRACK)

func play_level1() -> void:
	set_music(LEVEL1_TRACK)

func play_boss() -> void:
	DEFAULT_VOLUME_DB = -30.0
	set_music(BOSS_TRACK)

func play_win() -> void:
	set_music(WIN_TRACK)

func play_lose_timeout() -> void:
	set_music(LOSE_TIMEOUT_TRACK)
