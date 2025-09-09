extends Control

@onready var new_game_btn = $VBox/NewGame
@onready var hall_btn = $VBox/HallOfFame
@onready var exit_btn = $VBox/Exit

func _ready():
	new_game_btn.pressed.connect(_on_new_game_pressed)
	hall_btn.pressed.connect(_on_hall_pressed)
	exit_btn.pressed.connect(_on_exit_pressed)

func _on_new_game_pressed():
	# Change this to the path of your main game scene
	var game_scene_path = "res://Game.tscn"
	if ResourceLoader.exists(game_scene_path):
		get_tree().change_scene_to_file(game_scene_path)
	else:
		# fallback: just print a message
		print("New Game pressed - set `game_scene_path` in MainMenu.gd to your game scene")

func _on_hall_pressed():
	var hof_path = "res://HallOfFame.tscn"
	if ResourceLoader.exists(hof_path):
		get_tree().change_scene_to_file(hof_path)
	else:
		print("Hall of Fame scene not found at %s" % hof_path)

func _on_exit_pressed():
	get_tree().quit()
