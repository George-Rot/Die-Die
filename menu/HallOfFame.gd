extends Control

@onready var hall_list = $VBoxContainer/HallList

func _ready():
	load_hall_of_fame()

func load_hall_of_fame():
	var hall_data = GameData.get_hall_of_fame()
	
	if hall_data.is_empty():
		hall_list.text = "Nenhuma entrada no Hall da Fama ainda.\nSeja o primeiro a completar uma aventura!"
		return
	
	var hall_text = ""
	
	for i in range(hall_data.size()):
		var entry = hall_data[i]
		hall_text += str(i + 1) + ". "
		hall_text += entry.get("player_name", "Herói Desconhecido") + " - "
		hall_text += entry.get("class_name", "Classe Desconhecida") + "\n"
		hall_text += "   Andar Alcançado: " + str(entry.get("layer_reached", 0))
		
		if entry.get("completed", false):
			hall_text += " [color=gold](COMPLETOU A DUNGEON!)[/color]"
		
		hall_text += "\n"
		hall_text += "   Nível: " + str(entry.get("level", 1)) + " | "
		hall_text += "Ouro: " + str(entry.get("gold_earned", 0)) + "\n"
		hall_text += "   Data: " + entry.get("completion_date", "Data desconhecida") + "\n\n"
	
	hall_list.text = hall_text

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
