extends CharacterBody2D
class_name Player

var vitalidade: int
var forca: int
var agilidade: int
var overshield: int
var vida: int
var equip : loadout

@export var speed : int = 400
@onready var sprite := $PlayerSprite

func animate():
	if position.x > 0:
		sprite.play("right")
	elif velocity.x < 0:
		sprite.play("left")
	elif velocity.y > 0:
		sprite.play("down")
	elif velocity.y < 0:
		sprite.play("up")
	else:
		sprite.stop()

func get_8way_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	
func move_8way(delta):
	get_8way_input()
	animate()
	#move_and_slide()
	var collision_info := move_and_collide(velocity*delta)
	if collision_info:
		#print(collision_info.get_normal())
		velocity = velocity.bounce(collision_info.get_normal())
		move_and_collide(velocity * delta * 10)
	



func trocar_arma(nova_arma: equipamento):
	if equip.arma != null:
		forca -= equip.arma.forca
		agilidade -= equip.arma.agilidade
	equip.arma = nova_arma
	forca += nova_arma.forca
	agilidade += nova_arma.agilidade

func trocar_armadura(nova_armadura: armadura):
	if equip.armour != null:
		vitalidade -= equip.armadura.vitalidade
		overshield -= equip.armadura.overshield
	equip.armadura = nova_armadura
	vitalidade += nova_armadura.vitalidade
	overshield += nova_armadura.overshield

func _init(tipo: int):
	match tipo:
		0:
			vitalidade = 12
			forca = 12
			agilidade = 6
			overshield = 4
			vida = vitalidade
		1:
			vitalidade = 8
			forca = 10
			agilidade = 13
			overshield = 5
			vida = vitalidade
		_:
			# Valores padrão para outros tipos
			vitalidade = 10
			forca = 10
			agilidade = 10
			overshield = 0
			vida = vitalidade

func ataque_L():
	var chance = (agilidade * 2 - agilidade)
	var roll = randf_range(0, chance)
	if roll >= 20:
		var dano = (forca * (roll / 20))
		return dano
	return 0

func ataque_P():
	return forca + (forca * 0.5)

func defesa():
	overshield += vitalidade * 0.75
	
