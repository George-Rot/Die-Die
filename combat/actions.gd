extends Node
class_name Actions

static func light_attack(attacker_stats:Stats, target:Node) -> Dictionary:
	var RNG = load("res://autoLoad/rng.gd")
	var base = 7 + int(attacker_stats.forca * 0.0) # ajuste depois; esqueleto
	var crit = _roll_crit(attacker_stats.agilidade)
	var hits = 1
	# chance escalonada com agilidade de atingir 2x (ex.: agi%/100)
	if RNG.chance(min(attacker_stats.agilidade, 100)):
		hits = 2
	var dmg = base * hits
	if crit:
		dmg = int(dmg * 1.5)
	return {"damage": dmg, "crit": crit, "hits": hits}

static func heavy_attack(attacker_stats:Stats, target:Node) -> Dictionary:
	var base = 10 + int(attacker_stats.forca * 0.0) # ajuste depois
	var crit = _roll_crit(attacker_stats.agilidade)
	var dmg = base
	if crit:
		dmg = int(dmg * 1.75)
	return {"damage": dmg, "crit": crit}

static func block_action(user_stats:Stats, user:Node, incoming:int) -> int:
	return Damage.apply_block(incoming, user_stats.vitalidade, user.armor, user)

# Magias (esqueleto)
static func fireball(caster_stats:Stats, target:Node) -> Dictionary:
	var base = int(1.0 * caster_stats.conhecimento)
	var crit = _roll_crit(caster_stats.agilidade) # ou outra fórmula futura
	if crit:
		base = int(base * 1.5)
	return {"damage": base, "crit": crit}

static func ice_arrow(caster_stats:Stats, target:Node) -> Dictionary:
	var dmg = int(0.5 * caster_stats.conhecimento)
	# reduzir agilidade do alvo em 50% por 2 turnos -> aplicado no CombatManager via status effect
	return {"damage": dmg, "slow_pct": 50, "turns": 2}

static func barrier(caster_stats:Stats, user:Node) -> Dictionary:
	var shield_amount = int(1.0 * caster_stats.conhecimento)
	user.overshield += shield_amount
	return {"overshield": shield_amount}

static func _roll_crit(agilidade:int) -> bool:
	var RNG = load("res://autoLoad/rng.gd")
	# placeholder: chance = min(agilidade, 50)%
	return RNG.chance(min(agilidade, 50))
