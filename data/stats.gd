extends Resource
class_name Stats

@export var forca:int = 10
@export var agilidade:int = 10
@export var vitalidade:int = 10
@export var conhecimento:int = 10
@export var mana:int = 10

func copy() -> Stats:
	var s := Stats.new()
	s.forca = forca
	s.agilidade = agilidade
	s.vitalidade = vitalidade
	s.conhecimento = conhecimento
	s.mana = mana
	return s
