extends Node
class_name equipamento

var vitalidade: int
var forca: int
var agilidade: int
var inteligencia: int
var raridade: int

func _init(forc: int, vit: int, agil: int, inte: int, rar: int):
	vitalidade = vit
	forca = forc
	agilidade = agil
	inteligencia = inte
	raridade = rar

func getVitalidade():
	return vitalidade

func getForca():
	return forca

func getAgilidade():
	return agilidade

func getInteligencia():
	return inteligencia

func getRaridade():
	return raridade
