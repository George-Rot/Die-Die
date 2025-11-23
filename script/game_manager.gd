extends Node
var player : Player
var enemy : Enemy
var equip : equipamento
var armour : armadura

var xp = 0

# Character selection data
var selected_character = {}

# Player stats backup for battle
var player_stats_backup = {}

# Position and enemy management
var player_last_position = Vector2.ZERO
var defeated_enemies = []  # Lista de IDs de inimigos derrotados
var current_enemy_id = ""  # ID do inimigo atual em batalha
var battle_position = Vector2.ZERO  # Posição do player antes da batalha
var should_restore_position = false  # Flag para restaurar posição
var total_enemies = 0 # Total de inimigos no mapa

# Singleton para gerenciar dados do jogo
var player_position = Vector2(150, 150)  # Posição padrão
var player_stats = {
	"hp": 100,
	"max_hp": 100,
	"attack": 20,
	"defense": 5,
	"agility": 10
}

func incrXp(val: int):
	xp = xp + val
	if xp >= 100:
		xp -= 100
		# Save current position before level up
		should_restore_position = true
		# Trigger level up screen
		get_tree().change_scene_to_file("res://menu/LevelUp.tscn")
		

func save_player_for_battle(player_instance: Player):
	# Backup player stats for battle
	player_stats_backup = {
		"vitalidade": player_instance.vitalidade,
		"forca": player_instance.forca,
		"agilidade": player_instance.agilidade,
		"overshield": player_instance.overshield,
		"vida": player_instance.vida,
		"vida_atual": player_instance.vida  # HP atual para persistência
	}
	player = player_instance
func update_player_vida(nova_vida: int):
	# Atualiza a vida atual do player
	if player_stats_backup.has("vida_atual"):
		player_stats_backup.vida_atual = nova_vida
	if player:
		player.vida = nova_vida

func save_player_position(pos: Vector2):
	player_position = pos
	# position saved

func get_player_position() -> Vector2:
	return player_position

func reset_player_stats():
	player_stats.hp = player_stats.max_hp

func apply_character_stats_to_player():
	# Apply selected character stats to the player instance
	if selected_character.has("vitalidade") and player:
		player.vitalidade = selected_character.vitalidade
		player.forca = selected_character.forca
		player.agilidade = selected_character.agilidade
		player.overshield = 0
		# applied stats to player

func reset_character_selection():
	selected_character = {}
	player_stats_backup = {}
	player = null
	reset_defeated_enemies()  # Resetar inimigos quando novo personagem é selecionado
	# selection reset

func reset_vida_to_max():
	# Resetar vida para máxima baseada na vitalidade atual
	if selected_character.has("vitalidade"):
		var vida_maxima = selected_character.vitalidade * 10
		if player_stats_backup.has("vida_atual"):
			player_stats_backup.vida_atual = vida_maxima
		if player:
			player.vida = vida_maxima
		# vida resetada

func save_battle_position(pos: Vector2):
	# Salvar posição onde a batalha começou
	battle_position = pos
	# battle position saved

func get_battle_position() -> Vector2:
	return battle_position

func mark_enemy_defeated(enemy_id: String):
	# Marcar inimigo como derrotado
	if not defeated_enemies.has(enemy_id):
		defeated_enemies.append(enemy_id)
		# enemy marked defeated: %s

func defeat_enemy(enemy_id: String):
	# Marcar inimigo como derrotado (função alternativa)
	mark_enemy_defeated(enemy_id)

func is_enemy_defeated(enemy_id: String) -> bool:
	return defeated_enemies.has(enemy_id)

func reset_defeated_enemies():
	# Resetar inimigos derrotados (usado quando novo personagem é selecionado)
	defeated_enemies.clear()
	# defeated list reset
