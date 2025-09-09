extends Node2D

@onready var player = $Player
@onready var info_label = $CanvasLayer/UI/TopPanel/InfoLabel

var tile_size = 32
var grid_pos = Vector2i(4, 4)  # Posição inicial na grade

func _ready():
	print("SimpleMap1Test: Iniciado!")
	update_player_position()
	update_ui()

func _input(event):
	if event is InputEventKey and event.pressed:
		var old_pos = grid_pos
		
		match event.keycode:
			KEY_W, KEY_UP:
				grid_pos.y -= 1
			KEY_S, KEY_DOWN:
				grid_pos.y += 1
			KEY_A, KEY_LEFT:
				grid_pos.x -= 1
			KEY_D, KEY_RIGHT:
				grid_pos.x += 1
		
		# Limitar aos bounds do mapa (aproximados)
		grid_pos.x = clamp(grid_pos.x, 1, 33)
		grid_pos.y = clamp(grid_pos.y, 1, 25)
		
		if grid_pos != old_pos:
			update_player_position()
			update_ui()
			print("Player moveu para: ", grid_pos)

func update_player_position():
	var world_pos = Vector2(grid_pos.x * tile_size, grid_pos.y * tile_size)
	player.position = world_pos

func update_ui():
	info_label.text = "DUNGEON RPG - Use WASD para mover. Posição: (" + str(grid_pos.x) + "," + str(grid_pos.y) + ")"

func _on_reset_button_pressed():
	grid_pos = Vector2i(4, 4)
	update_player_position()
	update_ui()
	print("Posição resetada")

func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
