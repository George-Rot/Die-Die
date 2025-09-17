extends Control

@onready var new_game_btn = $VBoxContainer/NewGameButton
@onready var hall_btn = $VBoxContainer/HallOfFameButton
@onready var exit_btn = $VBoxContainer/QuitButton

func _ready():
	new_game_btn.pressed.connect(_on_new_game_button_pressed)
	hall_btn.pressed.connect(_on_hall_of_fame_button_pressed)
	exit_btn.pressed.connect(_on_quit_button_pressed)

func _on_new_game_button_pressed():
	# Ir para a tela de seleção de personagem
	get_tree().change_scene_to_file("res://menu/CharacterSelection.tscn")

func _on_hall_of_fame_button_pressed():
	get_tree().change_scene_to_file("res://menu/HallOfFame.tscn")

func _on_quit_button_pressed():
	get_tree().quit()
