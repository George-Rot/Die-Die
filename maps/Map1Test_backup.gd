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
	print("O enemy se move automaticamente e rebate nas paredes")
	
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
		player.vida = player.vitalidade
		var type_names = ["Cavaleiro", "Arqueiro", "Bandido"]
		print("Stats do personagem %s aplicados!" % type_names[GameManager.selected_character.type])
		print("Vitalidade: %d, Força: %d, Agilidade: %d" % [player.vitalidade, player.forca, player.agilidade])
	else:
		# Valores padrão se nenhum personagem foi selecionado
		player.setTtipo(0)  # Usar cavaleiro como padrão
		print("Nenhum personagem selecionado, usando Cavaleiro padrão")
	
	# Atualizar referência do GameManager para o player da cena
	GameManager.player = player
		print("Nenhum personagem selecionado, usando stats padrão")
	
	# Reset battle trigger when returning from battle
	if player.has_method("reset_battle_trigger"):
		player.call("reset_battle_trigger")

func _input(event):
	if event.is_action_pressed("ui_cancel"):  # ESC key
		print("Voltando ao menu principal...")
		get_tree().change_scene_to_file("res://menu/MainMenu.tscn")
