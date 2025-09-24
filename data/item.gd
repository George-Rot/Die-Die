extends Resource
class_name Item

enum Rarity { COMUM, RARO, EPICO, LENDARIO }

@export var name:String = ""
@export var rarity:Rarity = Rarity.COMUM
@export var slot:String = "" # "calcas", "armadura", "capacete", "espada_longa", "arco", "adaga", "cajado"
@export var allowed_classes:Array[int] = [] # coerência por classe
@export var stat_mods:Stats = Stats.new()
