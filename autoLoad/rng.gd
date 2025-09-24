extends Node
class_name RNG

var _rng := RandomNumberGenerator.new()

func _ready():
	_rng.randomize()

func randi_range(a:int, b:int) -> int:
	return _rng.randi_range(a,b)

func randf() -> float:
	return _rng.randf()

func chance(pct:float) -> bool:
	# pct de 0..100
	return _rng.randf() * 100.0 < pct
