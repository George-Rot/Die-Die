extends Node
class_name GameManager

signal layer_started(layer:int)
signal layer_cleared(layer:int)
signal dungeon_completed(total_layers:int)

var current_layer:int = 1
var max_layers:int = 10
var map_id:int = -1

var player:Node = null
var dungeon_state:Resource = null

func _ready():
	# Configure como autoload em Project > Autoload
	print("GameManager pronto")

func start_new_run(player_scene:PackedScene):
	player = player_scene.instantiate()
	current_layer = 1
	DungeonGenerator.new_run()
	_start_layer()

func _start_layer():
	map_id = DungeonGenerator.pick_map_for_layer(current_layer)
	emit_signal("layer_started", current_layer)
	print("Iniciando layer %s com mapa %s" % [current_layer, map_id])

func clear_layer():
	emit_signal("layer_cleared", current_layer)
	if current_layer >= max_layers:
		emit_signal("dungeon_completed", max_layers)
		return
	current_layer += 1
	_start_layer()
