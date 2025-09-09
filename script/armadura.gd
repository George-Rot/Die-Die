extends Node
class_name armadura

var vitalidade: int
var agilidade: int
var raridade: int

func _init(vit: int, agil: int, rar: int):
	vitalidade = vit
	agilidade = agil
	raridade = rar

func get_vitalidade():
	return vitalidade

func get_agilidade():
	return agilidade

func get_raridade():
	return raridade
