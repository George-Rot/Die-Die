extends Node
class_name Damage

static func apply_block(incoming:int, vitalidade:int, armor:int, carrier:Node) -> int:
	# bloqueio nega 1 * (vitalidade + armadura)
	var block_cap = vitalidade + armor
	var negated = min(incoming, block_cap)
	var leftover = max(0, incoming - negated)
	# dano que não ultrapassar vira overshield
	carrier.overshield += negated
	return leftover

static func apply_damage(amount:int, target:Node) -> void:
	var remaining = amount
	if target.overshield > 0:
		var use = min(target.overshield, remaining)
		target.overshield -= use
		remaining -= use
	if remaining > 0:
		target.hp -= remaining
