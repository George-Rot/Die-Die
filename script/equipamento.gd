extends Node
class_name equipamento

var vitalidade: int
var forca: int
var agilidade: int
var raridade: int

func _init(forc: int, agil: int, rar: int):
	forca = forc
	agilidade = agil
	raridade = rar

func getForca():
	return forca

func getAgilidade():
	return agilidade

func getRaridade():
	return raridade
