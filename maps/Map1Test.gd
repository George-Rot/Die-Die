extends Node2D

@onready var player = $Player
@onready var enemy = $Enemy
@onready var walls = $Walls

func _ready():
	print("Map1Test: Game iniciado!")
	print("Player e Enemy estão configurados com animações e movimentação!")
	print("Sistema de colisões ativo: Player e Enemy colidem com as paredes!")
	print("Sistema de batalha: Encoste no enemy para iniciar batalha!")
	print("Use WASD ou setas para mover o player")
	print("Use ESC para voltar ao menu principal")
	print("Use H para ver status do player")
	print("O enemy se move automaticamente e rebate nas paredes")
	
	# Verificar se inimigos foram derrotados e escondê-los
	check_defeated_enemies()
	
	# Configurar GameManager com referências do player e enemy
	GameManager.enemy = enemy
	print("GameManager configurado com enemy!")
	
	# Aplicar stats do personagem selecionado ou usar valores padrão
	if GameManager.selected_character.has("vitalidade"):
		# Copiar stats do player selecionado para o player da cena
		player.vitalidade = GameManager.selected_character.vitalidade
		player.forca = GameManager.selected_character.forca
		player.agilidade = GameManager.selected_character.agilidade
		player.overshield = 0
		
		# Usar vida atual se disponível, senão usar vida máxima (primeira vez)
		if GameManager.player_stats_backup.has("vida_atual") and GameManager.player_stats_backup.vida_atual > 0:
			player.vida = GameManager.player_stats_backup.vida_atual
			print("Usando vida atual persistente: %d" % player.vida)
		else:
			player.vida = player.vitalidade * 10  # Vida máxima na primeira vez
			print("Primeira vez no mapa, usando vida máxima: %d" % player.vida)
			
		var type_names = ["Cavaleiro", "Arqueiro", "Bandido"]
		print("Stats do personagem %s aplicados!" % type_names[GameManager.selected_character.type])
		print("Vitalidade: %d, Força: %d, Agilidade: %d, Vida: %d" % [player.vitalidade, player.forca, player.agilidade, player.vida])
	else:
		# Valores padrão se nenhum personagem foi selecionado
		player.setTtipo(0)  # Usar cavaleiro como padrão
		print("Nenhum personagem selecionado, usando Cavaleiro padrão")
	
	# Restaurar posição do player se voltando de batalha
	if GameManager.should_restore_position and GameManager.battle_position != Vector2.ZERO:
		player.global_position = GameManager.battle_position
		GameManager.should_restore_position = false
		print("Posição do player restaurada para: ", GameManager.battle_position)
	
	# Atualizar referência do GameManager para o player da cena
	GameManager.save_player_for_battle(player)
	print("GameManager.player configurado com stats:")
	print("Player HP calculado: %d (Vit %d x 10)" % [player.vitalidade * 10, player.vitalidade])
	print("GameManager.player reference: ", GameManager.player)
	
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
