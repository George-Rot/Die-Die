extends Node2D

@onready var player = $Player
@onready var enemy = $Enemy
@onready var walls = $Walls

func _ready():
	# Map ready
	print("nova agilidade")
	print(player.agilidade)
	print("novo id")
	print(GameManager.player)
	print("novo player stats")
	print(GameManager.player_stats)
	print("novo backups")
	print(GameManager.player_stats_backup)
	player = GameManager.player
	# Contar o total de inimigos no mapa (apenas na primeira vez)
	if GameManager.total_enemies == 0:
		var enemy_count = 0
		for child in get_children():
			if child is Enemy:
				enemy_count += 1
		GameManager.total_enemies = enemy_count
		# Log total enemies once for debugging
		print("Total de inimigos no mapa2: %d" % GameManager.total_enemies)
	# Verificar se inimigos foram derrotados e escondê-los
	check_defeated_enemies()
	
	# Configurar GameManager com referências do player e enemy
	GameManager.enemy = enemy
	
	# Aplicar stats do personagem selecionado ou usar valores padrão
	# Restaurar dados do backup se existirem (eles incluem melhorias de level up)
	player.vitalidade = GameManager.player_stats_backup.vitalidade
	player.forca = GameManager.player_stats_backup.forca
	player.agilidade = GameManager.player_stats_backup.agilidade
	player.vida = GameManager.player_stats_backup.vida_atual

	# Atualizar referência do GameManager para o player da cena
	GameManager.save_player_for_battle(player)
	print(player.agilidade)
	# Reset battle trigger when returning from battle
	if player.has_method("reset_battle_trigger"):
		player.call("reset_battle_trigger")

func check_defeated_enemies():
	# Verificar se o enemy principal foi derrotado
	if enemy and enemy.has_method("get_enemy_id"):
		var enemy_id = enemy.enemy_id
		if GameManager.is_enemy_defeated(enemy_id):
			# Usar função específica do enemy para desabilitá-lo completamente
			if enemy.has_method("disable_completely"):
				enemy.disable_completely()
			else:
				# Fallback manual caso a função não exista
				enemy.visible = false
				enemy.set_process(false)
				enemy.set_physics_process(false)
				enemy.set_collision_layer(0)
				enemy.set_collision_mask(0)
			
			print("Enemy " + enemy_id + " está derrotado, removido completamente do mapa")
	
	# Verificar todos os inimigos filhos também (se houverem)
	for child in get_children():
		if child is Enemy:
			var enemy_id = child.enemy_id
			if GameManager.is_enemy_defeated(enemy_id):
				# Usar função específica do enemy para desabilitá-lo completamente
				if child.has_method("disable_completely"):
					child.disable_completely()
				else:
					# Fallback manual caso a função não exista
					child.visible = false
					child.set_process(false)
					child.set_physics_process(false)
					child.set_collision_layer(0)
					child.set_collision_mask(0)
				
				print("Enemy " + enemy_id + " está derrotado, removido completamente do mapa")

func _input(event):
	if event.is_action_pressed("ui_cancel"):  # ESC key
		print("Voltando ao menu principal...")
		get_tree().change_scene_to_file("res://menu/MainMenu.tscn")
	
	# Mostrar vida atual com H
	if event.is_action_pressed("ui_accept") or Input.is_key_pressed(KEY_H):
		if player:
			print("=== STATUS DO PLAYER ===")
			print("Vida Atual: %d" % player.vida)
			print("Vitalidade: %d (HP Máximo: %d)" % [player.vitalidade, player.vitalidade * 10])
			print("Força: %d" % player.forca)
			print("Agilidade: %d" % player.agilidade)
			print("Overshield: %d" % player.overshield)
			print("========================")

func _process(delta):
	# Verificar se todos os inimigos foram derrotados
	check_map_completion()

func check_map_completion():
	# Contar quantos inimigos ainda estão vivos
	var defeated_count = 0
	
	for child in get_children():
		if child is Enemy:
			if GameManager.is_enemy_defeated(child.enemy_id):
				defeated_count += 1
	
	# Se todos os inimigos foram derrotados, teleportar para o próximo mapa
	if GameManager.total_enemies > 0 and defeated_count >= GameManager.total_enemies:
		print("Todos os inimigos derrotados! Teleportando para mapa3...")
		# Salvar posição do player antes de trocar de cena
		if player:
			GameManager.save_battle_position(player.global_position)
			GameManager.should_restore_position = true
		# Resetar contador de inimigos para o próximo mapa
		GameManager.total_enemies = 0
		# Trocar para o mapa 3
		GameManager.layer = 3
		get_tree().change_scene_to_file("res://maps/mapa3.tscn")
