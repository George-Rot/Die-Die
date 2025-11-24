extends Control

# Character stats definitions

func _ready():
	# Connect buttons (already connected in scene, but can add backup here)
	pass

func _on_knight_selected():
	print("Cavaleiro selecionado!")
	select_character(0)  # Cavaleiro = tipo 0
	GameManager.selectedClass = 0

func _on_archer_selected():
	print("Arqueiro selecionado!")
	select_character(1)  # Arqueiro = tipo 1
	GameManager.selectedClass = 1
func _on_rogue_selected():
	print("Bandido selecionado!")
	select_character(2)  # Bandido = tipo 2
	GameManager.selectedClass = 2

func select_character(character_type: int):
	# Create new player instance with selected character type
	var new_player = Player.new()
	new_player.setTtipo(character_type)
	
	# Store in GameManager
	GameManager.player = new_player
	GameManager.selected_character = {
		"type": character_type,
		"vitalidade": new_player.vitalidade,
		"forca": new_player.forca,
		"agilidade": new_player.agilidade
	}
	
	# Clear any previous backup to ensure fresh start
	GameManager.player_stats_backup = {}
	
	var type_names = ["Cavaleiro", "Arqueiro", "Bandido"]
	print("Personagem %s selecionado com stats:" % type_names[character_type])
	print("Vitalidade: %d, Força: %d, Agilidade: %d" % [new_player.vitalidade, new_player.forca, new_player.agilidade])
	print("Vida inicial: %d HP" % new_player.vida)
	
	# Start the game
	get_tree().change_scene_to_file("res://maps/mapa2.tscn")

func _on_back_pressed():
	# Return to main menu
	get_tree().change_scene_to_file("res://menu/MainMenu.tscn")
