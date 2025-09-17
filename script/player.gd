extends CharacterBody2D
class_name Player

var vitalidade: int
var forca: int
var agilidade: int
var overshield: int
var vida: int
var equip : loadout

@export var speed : int = 200
@onready var sprite := $AnimatedSprite2D
var can_battle = true  # Prevent multiple battle triggers

func _ready():
	print("Player _ready() chamado!")
	if speed == 0 or speed == null:
		speed = 200  # Garantir um valor válido
	print("Speed configurado: ", speed)
	sprite.play("idle")

func _physics_process(_delta):
	handle_movement()
	handle_animation()

func handle_movement():
	# Resetar velocidade
	velocity = Vector2.ZERO
	
	# Capturar input
	if Input.is_action_pressed("move_right") or Input.is_key_pressed(KEY_D):
		velocity.x += 1
	if Input.is_action_pressed("move_left") or Input.is_key_pressed(KEY_A):
		velocity.x -= 1
	if Input.is_action_pressed("move_down") or Input.is_key_pressed(KEY_S):
		velocity.y += 1
	if Input.is_action_pressed("move_up") or Input.is_key_pressed(KEY_W):
		velocity.y -= 1
	
	# Normalizar diagonal para manter velocidade consistente
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	# Usar move_and_slide() para movimento suave com colisões automáticas
	move_and_slide()
	
	# Check for collisions with other CharacterBody2D (like enemies)
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is Enemy and can_battle:
			print("Player colidiu com o enemy! Iniciando batalha...")
			can_battle = false
# Salva dados no singleton antes de trocar de cena
			GameManager.player = self  # ou self.get_status() se quiser só os stats
			GameManager.enemy = collider

			get_tree().change_scene_to_file("res://scenes/batalha_slime.tscn")

func handle_animation():
	# Animar baseado na velocidade
	if velocity.length() > 0:
		sprite.play("walk")
		# Flip sprite baseado na direção horizontal
		if velocity.x > 0:
			sprite.flip_h = false
		elif velocity.x < 0:
			sprite.flip_h = true
	else:
		# Idle animation when stopped
		sprite.play("idle")

func reset_battle_trigger():
	can_battle = true




func trocar_arma(nova_arma: equipamento):
	if equip.arma != null:
		forca -= equip.arma.forca
		agilidade -= equip.arma.agilidade
	equip.arma = nova_arma
	forca += nova_arma.forca
	agilidade += nova_arma.agilidade

func trocar_armadura(nova_armadura: armadura):
	if equip.armour != null:
		vitalidade -= equip.armour.vitalidade
		overshield -= equip.armour.overshield
	equip.armour = nova_armadura
	vitalidade += nova_armadura.vitalidade
	overshield += nova_armadura.overshield

func _init(tipo: int = 0):
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
	
