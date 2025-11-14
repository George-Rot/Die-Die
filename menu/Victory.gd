extends Control

@onready var title_label = $VBoxContainer/TitleLabel
@onready var message_label = $VBoxContainer/MessageLabel
@onready var stats_label = $VBoxContainer/StatsLabel
@onready var menu_button = $VBoxContainer/MenuButton

func _ready():
	# Configurar labels com informações do jogo
	var player_level = 1
	var enemies_defeated = len(GameManager.defeated_enemies)
	
	if GameManager.player_stats_backup.has("level"):
		player_level = GameManager.player_stats_backup.level
	
	stats_label.text = "Level Final: %d\nInimigos Derrotados: %d" % [player_level, enemies_defeated]
	
	# Conectar botão
	menu_button.pressed.connect(_on_menu_button_pressed)


func _on_menu_button_pressed():
	# Resetar o jogo para permitir uma nova partida
	GameManager.reset_defeated_enemies()
	GameManager.total_enemies = 0
	GameManager.player_leveled_up = false
	get_tree().change_scene_to_file("res://menu/MainMenu.tscn")
