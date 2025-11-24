extends Control

signal finished(equipped)

@onready var current_stats_label = $Panel/HBoxContainer/CurrentPanel/StatsLabel
@onready var new_stats_label = $Panel/HBoxContainer/NewPanel/StatsLabel
@onready var title_label = $Panel/TitleLabel
@onready var equip_button = $Panel/HBoxContainer2/EquipButton
@onready var discard_button = $Panel/HBoxContainer2/DiscardButton

var new_item
var item_type = "" # "weapon" or "armor"

func _ready():
	equip_button.pressed.connect(_on_equip_pressed)
	discard_button.pressed.connect(_on_discard_pressed)

func setup(current, dropped, type):
	new_item = dropped
	item_type = type
	
	var current_text = ""
	var new_text = ""
	
	var craridade = ""
	var raridade = ""
	
	
	match current.raridade:
		0:
			craridade = "comum"
		1:
			craridade = "incomum"
		2:
			craridade = "raro"
		3:
			craridade = "lendario"
	
	match dropped.raridade:
		0:
			raridade = "comum"
		1:
			raridade = "incomum"
		2:
			raridade = "raro"
		3:
			raridade = "lendario"
	
	
	if type == "weapon":
		title_label.text = "Nova Arma Encontrada!"
		if current:
			current_text = "Força: %d\nAgilidade: %d\nVitalidade: %d\nRaridade: %d" % [current.forca, current.agilidade, current.vitalidade, current.raridade]
		else:
			current_text = "Nenhum"
			
		new_text = "Força: %d\nAgilidade: %d\nVitalidade: %d\nRaridade: %d" % [dropped.forca, dropped.agilidade, dropped.vitalidade, dropped.raridade]
		
	elif type == "armor":
		title_label.text = "Nova Armadura Encontrada!"
		if current:
			current_text = "Vitalidade: %d\nAgilidade: %d\nRaridade: %d" % [current.vitalidade, current.agilidade, current.raridade]
		else:
			current_text = "Nenhum"
			
		new_text = "Vitalidade: %d\nAgilidade: %d\nRaridade: %d" % [dropped.vitalidade, dropped.agilidade, dropped.raridade]

	current_stats_label.text = current_text
	new_stats_label.text = new_text

func _on_equip_pressed():
	emit_signal("finished", true)
	queue_free()

func _on_discard_pressed():
	emit_signal("finished", false)
	queue_free()
