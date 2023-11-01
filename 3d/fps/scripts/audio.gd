extends Node
## Audio handler for a simple FPS game.
##
## Adapted from KidsCanCode.org/godot_recipes/4.x/audio/audio_manager/


const NUM_PLAYERS := 12
const BUS := "master"

var _available_players = []
var _sound_queue = []


func _ready():
	for i in NUM_PLAYERS:
		var p = AudioStreamPlayer.new()
		add_child(p)
		_available_players.append(p)
		p.volume_db = -10
		p.finished.connect(_on_stream_finished.bind(p))
		p.bus = BUS


func _on_stream_finished(stream):
	_available_players.append(stream)


func play(sound_paths):
	var sounds = sound_paths.split(",")
	_sound_queue.append("res://" +
			sounds[randi() % sounds.size()].strip_edges())


func _process(_delta):
	if not _sound_queue.is_empty() and not _available_players.is_empty():
		_available_players[0].stream = load(_sound_queue.pop_front())
		_available_players[0].play()
		_available_players[0].pitch_scale = randf_range(0.9, 1.1)
		_available_players.pop_front()
