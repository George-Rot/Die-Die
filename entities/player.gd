extends Node
class_name Player

@export var class_type:int = Classes.ClassType.CAVALEIRO
@export var base_stats:Stats = Stats.new()

var equipment := Equipment.new()
var inventory := Inventory.new()
var xp_system := XPSystem.new()

var hp:int = 100
var armor:int = 0
var overshield:int = 0

func _ready():
	add_child(equipment)
	add_child(inventory)
	add_child(xp_system)

func total_stats() -> Stats:
	var s := base_stats.copy()
	var mods := equipment.total_mods()
	s.forca += mods.forca
	s.agilidade += mods.agilidade
	s.vitalidade += mods.vitalidade
	s.conhecimento += mods.conhecimento
	s.mana += mods.mana
	return s
