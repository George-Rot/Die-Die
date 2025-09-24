extends Node
class_name ItemFactory


static func make_random_item(class_type:int) -> Item:
	var RNG = load("res://autoLoad/rng.gd")
	var item := Item.new()
	var slots = Classes.allowed_slots(class_type)
	item.slot = slots[RNG.randi_range(0, slots.size()-1)]
	item.rarity = _roll_rarity()
	item.name = "%s %s" % [str(item.rarity), item.slot]
	item.allowed_classes = [class_type]
	item.stat_mods = _roll_stats(item.rarity)
	return item

static func _roll_rarity() -> int:
	var RNG = load("res://autoLoad/rng.gd")
	# espectro simples: 60% comum, 25% raro, 12% épico, 3% lendário
	var roll = RNG.randf()
	if roll < 0.60:
		return Item.Rarity.COMUM
	elif roll < 0.85:
		return Item.Rarity.RARO
	elif roll < 0.97:
		return Item.Rarity.EPICO
	else:
		return Item.Rarity.LENDARIO

static func _roll_stats(rarity:int) -> Stats:
	var RNG = load("res://autoLoad/rng.gd")
	var s := Stats.new()
	var mult = 1
	match rarity:
		Item.Rarity.COMUM: mult = 1
		Item.Rarity.RARO: mult = 2
		Item.Rarity.EPICO: mult = 3
		Item.Rarity.LENDARIO: mult = 5
	# distribuição simples para esqueleto
	s.forca += RNG.randi_range(0,2) * mult
	s.agilidade += RNG.randi_range(0,2) * mult
	s.vitalidade += RNG.randi_range(0,2) * mult
	s.conhecimento += RNG.randi_range(0,2) * mult
	s.mana += RNG.randi_range(0,2) * mult
	return s
