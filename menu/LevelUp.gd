extends Control

@onready var stats_label = $VBoxContainer/StatsLabel
@onready var vitality_button = $VBoxContainer/HBoxContainer/VitalityButton
@onready var strength_button = $VBoxContainer/HBoxContainer/StrengthButton
@onready var agility_button = $VBoxContainer/HBoxContainer/AgilityButton
@onready var continue_button = $VBoxContainer/ContinueButton
@onready var points_label = $VBoxContainer/PointsLabel

var player: Player
var available_points: int = 3
var temp_vitality: int = 0
var temp_strength: int = 0
var temp_agility: int = 0

func _ready():
	# Ensure we have player data
	if GameManager.player:
		player = GameManager.player
	elif GameManager.player_stats_backup.size() > 0:
		# Fallback: create player from backup
		player = Player.new()
		player.vitalidade = GameManager.player_stats_backup.get("vitalidade", 10)
		player.forca = GameManager.player_stats_backup.get("forca", 10)
		player.agilidade = GameManager.player_stats_backup.get("agilidade", 10)
		player.vida = GameManager.player_stats_backup.get("vida", 100)
	else:
		# Emergency fallback: use default values
		push_error("No player data available in GameManager")
		player = Player.new()
		player.vitalidade = 10
		player.forca = 10
		player.agilidade = 10
		player.vida = 100

	update_stats_label()
	update_points_label()

	vitality_button.pressed.connect(_on_vitality_pressed)
	strength_button.pressed.connect(_on_strength_pressed)
	agility_button.pressed.connect(_on_agility_pressed)
	continue_button.pressed.connect(_on_continue_pressed)
	
	# All buttons start enabled
	vitality_button.disabled = false
	strength_button.disabled = false
	agility_button.disabled = false
	continue_button.disabled = true  # Disabled until points are spent

func update_stats_label():
	var current_vit = player.vitalidade + temp_vitality
	var current_str = player.forca + temp_strength
	var current_agi = player.agilidade + temp_agility
	var current_hp = current_vit * 10
	
	stats_label.text = "LEVEL UP!\n\nStatus Atuais:\n\nVitalidade: %d (HP: %d)%s\nForça: %d%s\nAgilidade: %d%s" % [
		current_vit, 
		current_hp,
		(" (+%d)" % temp_vitality) if temp_vitality > 0 else "",
		current_str,
		(" (+%d)" % temp_strength) if temp_strength > 0 else "",
		current_agi,
		(" (+%d)" % temp_agility) if temp_agility > 0 else ""
	]

func update_points_label():
	points_label.text = "Pontos disponíveis: %d" % available_points
	
	# Disable buttons if no points available
	if available_points <= 0:
		vitality_button.disabled = true
		strength_button.disabled = true
		agility_button.disabled = true
		continue_button.disabled = false
	else:
		vitality_button.disabled = false
		strength_button.disabled = false
		agility_button.disabled = false
		continue_button.disabled = true

func _on_vitality_pressed():
	if available_points > 0:
		temp_vitality += 1
		available_points -= 1
		update_stats_label()
		update_points_label()

func _on_strength_pressed():
	if available_points > 0:
		temp_strength += 1
		available_points -= 1
		update_stats_label()
		update_points_label()

func _on_agility_pressed():
	if available_points > 0:
		temp_agility += 1
		available_points -= 1
		update_stats_label()
		update_points_label()

func _on_continue_pressed():
	# Apply all accumulated points to player
	player.vitalidade += temp_vitality
	player.forca += temp_strength
	player.agilidade += temp_agility
	player.vida = player.vitalidade * 10
	
	# Update GameManager backup - ensure it exists
	if GameManager.player_stats_backup.size() == 0:
		GameManager.player_stats_backup = {}
	
	GameManager.player_stats_backup.vitalidade = player.vitalidade
	GameManager.player_stats_backup.forca = player.forca
	GameManager.player_stats_backup.agilidade = player.agilidade
	GameManager.player_stats_backup.vida = player.vida
	GameManager.player_stats_backup.vida_atual = player.vida  # Restore HP to max
	
	# Update GameManager player reference if it exists
	if GameManager.player:
		GameManager.player.vitalidade = player.vitalidade
		GameManager.player.forca = player.forca
		GameManager.player.agilidade = player.agilidade
		GameManager.player.vida = player.vida
	
	GameManager.update_player_vida(player.vida)
	
	# Return to map
	GameManager.should_restore_position = true
	get_tree().change_scene_to_file("res://maps/mapa2.tscn")
