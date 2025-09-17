extends Control

# Battle player instance with real stats
var battle_player
var act_enemy
var player_hp : int
var player_max_hp : int
var enemy_hp : int
var enemy_max_hp : int 

var enemy_attack = 15
var is_defending = false
var defense_boost = 0

# UI References
@onready var player_hp_bar = $BattleUI/TopPanel/PlayerStats/PlayerHPBar
@onready var player_hp_label = $BattleUI/TopPanel/PlayerStats/PlayerHPLabel
@onready var enemy_hp_bar = $BattleUI/TopPanel/EnemyStats/EnemyHPBar
@onready var enemy_hp_label = $BattleUI/TopPanel/EnemyStats/EnemyHPLabel
@onready var message_label = $BattleUI/MessagePanel/MessageLabel

@onready var attack_button = $BattleUI/ActionPanel/ActionButtons/AttackButton
@onready var quick_attack_button = $BattleUI/ActionPanel/ActionButtons/QuickAttackButton
@onready var defend_button = $BattleUI/ActionPanel/ActionButtons/DefendButton
@onready var flee_button = $BattleUI/ActionPanel/ActionButtons/FleeButton

func _ready():
	print("Batalha iniciada!")
	
	# Verificar se o GameManager e player existem
	if not GameManager:
		print("ERRO: GameManager não encontrado!")
		return
	if not GameManager.player:
		print("ERRO: GameManager.player não encontrado!")
		return
		
	print("GameManager e player validados!")
	
	# Configurar referências locais
	battle_player = GameManager.player
	act_enemy = GameManager.enemy
	
	print("Referências locais configuradas")
	
	create_battle_player()
	create_battle_enemy()
	setup_ui()
	connect_buttons()
	update_ui()
	message_label.text = "Um Slime selvagem apareceu! Selecione sua ação:"

func create_battle_player():
	# Verificar se o player tem stats válidos, senão usar valores padrão
	if battle_player.vitalidade == 0 or battle_player.vitalidade == null:
		print("AVISO: Vitalidade do player é 0 ou null, usando valor padrão")
		battle_player.vitalidade = 10
	if battle_player.forca == 0 or battle_player.forca == null:
		print("AVISO: Força do player é 0 ou null, usando valor padrão")
		battle_player.forca = 15
	if battle_player.agilidade == 0 or battle_player.agilidade == null:
		print("AVISO: Agilidade do player é 0 ou null, usando valor padrão")
		battle_player.agilidade = 8
		
	player_max_hp = battle_player.vitalidade * 10
	player_hp = player_max_hp
	print("Player stats - Força: %d, Agilidade: %d, Vitalidade: %d" % [battle_player.forca, battle_player.agilidade, battle_player.vitalidade])
	print("Player HP: %d/%d" % [player_hp, player_max_hp])
	print("Ataque Ágil pode fazer até %d tentativas de acerto!" % battle_player.agilidade)

func create_battle_enemy():
	# Inicializar stats do inimigo Slime
	enemy_max_hp = 50
	enemy_hp = enemy_max_hp
	print("Enemy Slime stats - HP: %d/%d, Attack: %d" % [enemy_hp, enemy_max_hp, enemy_attack])

func multiple_agility_attacks():
	# Simulate multiple attacks based on agility - each agility point = one attack attempt
	var total_damage = 0
	var hits = 0
	var max_attempts = battle_player.agilidade
	
	# Cada ponto de agilidade = uma tentativa de ataque
	for i in range(max_attempts):
		var damage = battle_player.ataque_L(10) # Usando agilidade padrão do slime = 10
		if damage > 0:
			total_damage += damage
			hits += 1
	
	return {"damage": total_damage, "hits": hits}

func setup_ui():
	# Verificar se as referências da UI estão corretas
	if not player_hp_bar:
		print("ERRO: player_hp_bar não encontrado!")
		return
	if not enemy_hp_bar:
		print("ERRO: enemy_hp_bar não encontrado!")
		return
	if not player_hp_label:
		print("ERRO: player_hp_label não encontrado!")
		return
	if not enemy_hp_label:
		print("ERRO: enemy_hp_label não encontrado!")
		return
	
	print("UI Referencias validadas com sucesso!")
	
	# Set initial HP values for enemy
	enemy_hp_bar.max_value = enemy_max_hp
	enemy_hp_bar.value = enemy_hp
	
	# Set initial HP values for player
	player_hp_bar.max_value = player_max_hp
	player_hp_bar.value = player_hp

func connect_buttons():
	if not attack_button:
		print("ERRO: attack_button não encontrado!")
		return
	if not quick_attack_button:
		print("ERRO: quick_attack_button não encontrado!")
		return
	if not defend_button:
		print("ERRO: defend_button não encontrado!")
		return
	if not flee_button:
		print("ERRO: flee_button não encontrado!")
		return
		
	print("Botões validados com sucesso!")
	
	attack_button.pressed.connect(_on_attack_pressed)
	quick_attack_button.pressed.connect(_on_quick_attack_pressed)
	defend_button.pressed.connect(_on_defend_pressed)
	flee_button.pressed.connect(_on_flee_pressed)

func _on_attack_pressed():
	disable_buttons()
	# Use the player's ataque_P() function for heavy attack
	var damage = int(battle_player.ataque_P(10))
	enemy_hp -= damage
	enemy_hp = max(0, enemy_hp)
	
	message_label.text = "Player usou Ataque Poderoso! Causou %d de dano!" % damage
	update_ui()
	
	await get_tree().create_timer(1.5).timeout
	
	if enemy_hp <= 0:
		victory()
	else:
		enemy_turn()

func _on_quick_attack_pressed():
	disable_buttons()
	# Use multiple attack system based on agility
	var attack_result = multiple_agility_attacks()
	var total_damage = attack_result.damage
	var hits = attack_result.hits
	var max_possible = battle_player.agilidade
	
	if hits > 0:
		enemy_hp -= total_damage
		enemy_hp = max(0, enemy_hp)
		if hits == 1:
			message_label.text = "Ataque Ágil! 1/%d acerto causou %d de dano!" % [max_possible, total_damage]
		elif hits == max_possible:
			message_label.text = "Ataque Ágil! COMBO PERFEITO! %d/%d acertos = %d dano!" % [hits, max_possible, total_damage]
		else:
			message_label.text = "Ataque Ágil! %d/%d acertos em combo = %d dano total!" % [hits, max_possible, total_damage]
	else:
		message_label.text = "Ataque Ágil falhou! 0/%d acertos conectados!" % max_possible
	
	update_ui()
	
	await get_tree().create_timer(1.5).timeout
	
	if enemy_hp <= 0:
		victory()
	else:
		enemy_turn()

func _on_defend_pressed():
	disable_buttons()
	is_defending = true
	# Use the player's defesa() function and calculate defense boost
	var old_overshield = battle_player.overshield
	battle_player.defesa()
	defense_boost = battle_player.overshield - old_overshield
	
	message_label.text = "Player se defendeu! Ganhou %d de escudo extra!" % defense_boost
	
	await get_tree().create_timer(1.5).timeout
	enemy_turn()

func _on_flee_pressed():
	disable_buttons()
	message_label.text = "Você fugiu da batalha!"
	
	await get_tree().create_timer(1.5).timeout
	return_to_map()

func enemy_turn():
	var damage = enemy_attack + randi_range(-3, 3)
	var original_damage = damage
	
	if is_defending:
		# Apply defense using overshield first, then HP
		if battle_player.overshield > 0:
			var shield_damage = min(damage, battle_player.overshield)
			battle_player.overshield -= shield_damage
			damage -= shield_damage
			
			if damage > 0:
				player_hp -= damage
				message_label.text = "Slime atacou com %d! Escudo absorveu %d, você recebeu %d de dano!" % [original_damage, shield_damage, damage]
			else:
				message_label.text = "Slime atacou com %d! Escudo absorveu todo o dano!" % original_damage
		else:
			damage = max(1, damage - defense_boost)  # Minimum 1 damage
			player_hp -= damage
			message_label.text = "Slime atacou com %d! Defesa reduziu para %d de dano!" % [original_damage, damage]
		is_defending = false
		defense_boost = 0
	else:
		message_label.text = "Slime atacou! Causou %d de dano!" % damage
		player_hp -= damage
	
	player_hp = max(0, player_hp)
	update_ui()
	
	await get_tree().create_timer(1.5).timeout
	
	if player_hp <= 0:
		defeat()
	else:
		player_turn()

func player_turn():
	message_label.text = "Sua vez! Selecione uma ação:"
	enable_buttons()

func victory():
	message_label.text = "Vitória! Você derrotou o Slime!"
	disable_buttons()
	
	await get_tree().create_timer(2.0).timeout
	return_to_map()

func defeat():
	message_label.text = "Derrota! Você foi derrotado pelo Slime!"
	disable_buttons()
	
	await get_tree().create_timer(2.0).timeout
	return_to_map()

func return_to_map():
	get_tree().change_scene_to_file("res://maps/Map1Test.tscn")

func update_ui():
	print("Atualizando UI - Player HP: %d/%d, Enemy HP: %d/%d" % [player_hp, player_max_hp, enemy_hp, enemy_max_hp])
	
	player_hp_bar.value = player_hp
	if battle_player.overshield > 0:
		player_hp_label.text = "HP: %d/%d (+%d escudo)" % [player_hp, player_max_hp, battle_player.overshield]
	else:
		player_hp_label.text = "HP: %d/%d" % [player_hp, player_max_hp]
	
	enemy_hp_bar.value = enemy_hp
	enemy_hp_label.text = "HP: %d/%d" % [enemy_hp, enemy_max_hp]
	
	print("UI atualizada com sucesso!")

func disable_buttons():
	attack_button.disabled = true
	quick_attack_button.disabled = true
	defend_button.disabled = true
	flee_button.disabled = true

func enable_buttons():
	attack_button.disabled = false
	quick_attack_button.disabled = false
	defend_button.disabled = false
	flee_button.disabled = false
