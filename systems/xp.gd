extends Node
class_name XPSystem

signal xp_changed(current:int, next_level:int)

var level:int = 1
var xp:int = 0
var xp_to_next:int = 100 # base; você ajustará depois

func add_xp(amount:int) -> void:
	xp += amount
	emit_signal("xp_changed", xp, xp_to_next)
	while xp >= xp_to_next:
		xp -= xp_to_next
		level += 1
		xp_to_next = int(xp_to_next * 1.25)
		emit_signal("xp_changed", xp, xp_to_next)
