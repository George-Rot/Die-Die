extends Control

# Battle player instance with real stats
var battle_player
var act_enemy
var player_hp : int
var player_max_hp : int
var enemy_hp : int
var enemy_max_hp : int 

# Removed unused variables that were shadowing class names
# var equipamento : equipamento
# var newEquip : equipamento

var enemy_attack = 6
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
	# Battle ready
	if not GameManager:
		print("ERRO: GameManager não encontrado!")
		return
	
	# Verificar se temos stats do player ou player válido
	if GameManager.player:
		battle_player = GameManager.player
	elif GameManager.player_stats_backup.has("vitalidade"):
		# use backup stats
		# Criar player temporário com stats backup
		battle_player = Player.new()
		battle_player.vitalidade = GameManager.player_stats_backup.vitalidade
		battle_player.forca = GameManager.player_stats_backup.forca
		battle_player.agilidade = GameManager.player_stats_backup.agilidade
		battle_player.overshield = GameManager.player_stats_backup.overshield
		battle_player.vida = GameManager.player_stats_backup.vida
		
		# restored level and xp from backup
	else:
		print("ERRO: Nenhum player ou stats encontrados!")
		return
		
	# Player validated for battle
	
	# Configurar enemy
	act_enemy = GameManager.enemy
	
	# Enemy reference set
	
	create_battle_player()
	create_battle_enemy()
	setup_ui()
	connect_buttons()
	update_ui()
	message_label.text = "Um Slime selvagem apareceu! Selecione sua ação:"

func create_battle_player():
	# Verificar se o player tem stats válidos, senão usar valores padrão
	if battle_player.vitalidade == 0 or battle_player.vitalidade == null:
		battle_player.vitalidade = 10
	if battle_player.forca == 0 or battle_player.forca == null:
		battle_player.forca = 15
	if battle_player.agilidade == 0 or battle_player.agilidade == null:
		battle_player.agilidade = 8
		
	# Ensure loadout is initialized for battle player
	if battle_player.equip == null:
		var default_weapon = equipamento.new(0, 0, 0)
		var default_armor = armadura.new(0, 0, 0)
		battle_player.equip = loadout.new(default_weapon, default_armor)
		
	player_max_hp = battle_player.vitalidade * 10
	
	# Usar vida atual se disponível E maior que 0, senão usar vida máxima
	if GameManager.player_stats_backup.has("vida_atual") and GameManager.player_stats_backup.vida_atual > 0:
		player_hp = GameManager.player_stats_backup.vida_atual
	else:
		player_hp = player_max_hp
	
	# Player stats and HP initialized for battle

func create_battle_enemy():
	# Inicializar stats do inimigo Slime
	enemy_max_hp = 50
	enemy_hp = enemy_max_hp
	# Enemy stats initialized

func multiple_agility_attacks():
	# Simulate multiple attacks based on agility - each agility point = one attack attempt
	var total_damage = 0
	var hits = 1
	# Cada ponto de agilidade = uma tentativa de ataque
	total_damage = battle_player.ataque_L() # Usando agilidade padrão do slime = 10

	
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
	
	# UI references validated
	
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
		
	# Buttons connected
	
	attack_button.pressed.connect(_on_attack_pressed)
	quick_attack_button.pressed.connect(_on_quick_attack_pressed)
	defend_button.pressed.connect(_on_defend_pressed)
	flee_button.pressed.connect(_on_flee_pressed)

func _on_attack_pressed():
	disable_buttons()
	# Use the player's ataque_P() function for heavy attack
	var damage = int(battle_player.ataque_P(10)) #variavel que vai eh a agilidade do inimigo -> chance de esquiva
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
		message_label.text = "Ataque Ágil! acerto causou %d de dano!" % [total_damage]
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
	# Salvar vida atual do player
	GameManager.update_player_vida(player_hp)
	
	# Chance de dropar um item (60% de chance)
	var drop_roll = randi_range(0, 99)
	if drop_roll > 1:
		var is_weapon = randi() % 2 == 0
		var rarity_roll = randi_range(0, 99)
		
		var min_stat = 0
		var max_stat = 0
		var rarity_val = 0
		
		# 5% Legendary, 10% Epic, 20% Rare, 25% Uncommon, 40% Common (Normalized to 100)
		if rarity_roll < 5: # 5%
			min_stat = 15
			max_stat = 25
			rarity_val = 4 # Legendary
		elif rarity_roll < 15: # 10% (5+10)
			min_stat = 15
			max_stat = 20
			rarity_val = 3 # Epic
		elif rarity_roll < 35: # 20% (15+20)
			min_stat = 10
			max_stat = 20
			rarity_val = 2 # Rare
		elif rarity_roll < 60: # 25% (35+25)
			min_stat = 5
			max_stat = 15
			rarity_val = 1 # Uncommon
		else: # 40% (Remaining)
			min_stat = 5
			max_stat = 10
			rarity_val = 0 # Common
			
		# Instantiate ItemDrop screen
		var item_drop_scene = load("res://menu/ItemDrop.tscn").instantiate()
		add_child(item_drop_scene)
		
		if is_weapon:
			var dmg = randi_range(min_stat, max_stat)
			var agi = randi_range(min_stat, max_stat)
			var new_weapon = equipamento.new(dmg, agi, rarity_val)
			
			# Setup UI
			var act = GameManager.equip
			item_drop_scene.setup(act, new_weapon, "weapon")
			
			# Wait for user choice
			var equipped = await item_drop_scene.finished
			
			if equipped:
				battle_player.trocar_arma(new_weapon)
				GameManager.equip = new_weapon
				message_label.text = "Vitória! Nova arma equipada!"
			else:
				message_label.text = "Vitória! Item descartado."
				
		else:
			var vit = randi_range(min_stat, max_stat)
			var agi = randi_range(min_stat, max_stat) / 3
			var new_armor = armadura.new(vit, agi, rarity_val)
			
			# Setup UI
			item_drop_scene.setup(GameManager.armour, new_armor, "armor")
			
			# Wait for user choice
			var equipped = await item_drop_scene.finished
			
			if equipped:
				battle_player.trocar_armadura(new_armor)
				GameManager.armour = new_armor
				message_label.text = "Vitória! Nova armadura equipada!"
			else:
				message_label.text = "Vitória! Item descartado."
			
		# Persist stats to GameManager (only if changed, but safe to update anyway)
		GameManager.player_stats_backup.vitalidade = battle_player.vitalidade
		GameManager.player_stats_backup.forca = battle_player.forca
		GameManager.player_stats_backup.agilidade = battle_player.agilidade
		if GameManager.player:
			GameManager.player.vitalidade = battle_player.vitalidade
			GameManager.player.forca = battle_player.forca
			GameManager.player.agilidade = battle_player.agilidade
	else:
		message_label.text = "Vitória! Você derrotou o Slime!"
	
	# Victory handling

	# Marcar inimigo como derrotado
	if GameManager.current_enemy_id != "":
		GameManager.mark_enemy_defeated(GameManager.current_enemy_id)
	
	disable_buttons()
	
	# Check if still in tree before awaiting
	if not is_inside_tree():
		return
	
	await get_tree().create_timer(2.0).timeout
	
	# Incrementar XP após o timer para evitar mudança de cena prematura
	if GameManager.current_enemy_id != "":
		GameManager.incrXp(50)
		# Se mudou de cena para level up, não continua
		if not is_inside_tree():
			return
	
	# Verificar se todos os inimigos foram derrotados
	if GameManager.total_enemies > 0 and len(GameManager.defeated_enemies) >= GameManager.total_enemies:
		get_tree().change_scene_to_file("res://menu/Victory.tscn")
		return
	
	return_to_map()

func defeat():
	message_label.text = "Derrota! Você foi derrotado pelo Slime!"
	disable_buttons()
	
	await get_tree().create_timer(2.0).timeout
	# Ir para tela de game over em vez de voltar ao mapa
	get_tree().change_scene_to_file("res://menu/GameOver.tscn")

func return_to_map():
	# Salvar vida atual antes de voltar ao mapa
	GameManager.update_player_vida(player_hp)
	
	# Sinalizar que precisa restaurar posição
	GameManager.should_restore_position = true
	
	get_tree().change_scene_to_file("res://maps/Map1Test.tscn")

func update_ui():
	player_hp_bar.value = player_hp
	if battle_player.overshield > 0:
		player_hp_label.text = "HP: %d/%d (+%d escudo)" % [player_hp, player_max_hp, battle_player.overshield]
	else:
		player_hp_label.text = "HP: %d/%d" % [player_hp, player_max_hp]
	
	enemy_hp_bar.value = enemy_hp
	enemy_hp_label.text = "HP: %d/%d" % [enemy_hp, enemy_max_hp]


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
