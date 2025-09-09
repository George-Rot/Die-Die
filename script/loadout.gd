extends Node
class_name loadout

var arma: equipamento
var armour: armadura

func _init(arma_obj: equipamento, armour_obj: armadura):
	arma = arma_obj
	armour = armour_obj

func get_arma():
	return arma

func get_armour():
	return armour
