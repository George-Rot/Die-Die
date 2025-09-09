extends Node

# Singleton para gerenciar dados do jogo
var player_position = Vector2(150, 150)  # Posição padrão
var player_stats = {
	"hp": 100,
	"max_hp": 100,
	"attack": 20,
	"defense": 5,
	"agility": 10
}

func save_player_position(pos: Vector2):
	player_position = pos
	print("Posição do player salva: ", pos)

func get_player_position() -> Vector2:
	return player_position

func reset_player_stats():
	player_stats.hp = player_stats.max_hp
