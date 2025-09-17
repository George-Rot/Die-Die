extends Control

func _ready():
	print("Game Over screen loaded")

func _on_continue_pressed():
	print("Continue pressed - resetting character and going to main menu")
	# Reset character selection to force new character creation
	GameManager.reset_character_selection()
	# Go to main menu
	get_tree().change_scene_to_file("res://menu/MainMenu.tscn")

func _on_main_menu_pressed():
	print("Main menu pressed - going to main menu")
	# Reset character selection
	GameManager.reset_character_selection()
	# Go to main menu
	get_tree().change_scene_to_file("res://menu/MainMenu.tscn")
