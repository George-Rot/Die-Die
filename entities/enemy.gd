extends Node
class_name Enemy

@export var name:String = "Goblin"
@export var layer:int = 1
@export var is_boss:bool = false

var stats:Stats = Stats.new()
var hp:int = 50
var armor:int = 0
var overshield:int = 0

func _ready():
	# Goblins têm 5 de status + (layer atual)
	stats.forca = 5 + layer
	stats.agilidade = 5 + layer
	stats.vitalidade = 5 + layer
	stats.conhecimento = 5 + layer
	stats.mana = 5 + layer
	if is_boss:
		var mult = 2 * layer # layer de chefe é 2,4,6,8 ou 10
		stats.forca *= mult
		stats.agilidade *= mult
		stats.vitalidade *= mult
		stats.conhecimento *= mult
		stats.mana *= mult
