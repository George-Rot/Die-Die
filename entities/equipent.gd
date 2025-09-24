extends Node
class_name Equipment

var slots := {
	"calcas": null,
	"armadura": null,
	"capacete": null,
	"espada_longa": null,
	"arco": null,
	"adaga": null,
	"cajado": null,
}

func can_equip(item:Item, class_type:int) -> bool:
	return item and item.slot in slots and class_type in item.allowed_classes

func equip(item:Item, class_type:int) -> bool:
	if can_equip(item, class_type):
		slots[item.slot] = item
		return true
	return false

func total_mods() -> Stats:
	var s := Stats.new()
	for v in slots.values():
		if v:
			s.forca += v.stat_mods.forca
			s.agilidade += v.stat_mods.agilidade
			s.vitalidade += v.stat_mods.vitalidade
			s.conhecimento += v.stat_mods.conhecimento
			s.mana += v.stat_mods.mana
	return s
