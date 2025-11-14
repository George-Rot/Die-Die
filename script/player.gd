extends CharacterBody2D
class_name Player

var vitalidade: int
var forca: int
var agilidade: int
var overshield: int
var vida: int
var equip : loadout
var tipo : int

@export var speed : int = 200
@onready var sprite := $AnimatedSprite2D
var can_battle = true  # Prevent multiple battle triggers

func setTtipo(tip: int):
	match tip:
		0:
			vitalidade = 15
			forca = 10
			agilidade = 6
			overshield = 0
			vida = vitalidade * 10  # Vida real baseada na vitalidade
		1:
			vitalidade = 8
			forca = 10
			agilidade = 14
			overshield = 5
			vida = vitalidade * 10  # Vida real baseada na vitalidade
		2:
			# Valores padrão para outros tipos
			vitalidade = 6
			forca = 12
			agilidade = 20
			overshield = 8
			vida = vitalidade * 10  # Vida real baseada na vitalidade
	
	return 0

func _ready():
	# Ready: initialize player visuals and speed
	if speed == 0 or speed == null:
		speed = 200  # Garantir um valor válido
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
			# Verificar se o inimigo está visível e ativo
			if not collider.visible or not collider.process_mode == Node.PROCESS_MODE_INHERIT:
				# enemy invisible or inactive; ignore collision
				continue
			# Verificar se este inimigo já foi derrotado
			var enemy_id = collider.enemy_id
			if GameManager.is_enemy_defeated(enemy_id):
				# already defeated
				continue
			
			can_battle = false
			
			# Salvar posição atual antes da batalha
			GameManager.save_battle_position(global_position)
			
			# Salvar ID do inimigo que será enfrentado
			GameManager.current_enemy_id = enemy_id
			
			# Salva dados no singleton antes de trocar de cena
			GameManager.save_player_for_battle(self)
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

func ataque_L(agilInimigo: int):
	var chance = (agilidade * agilidade/2 - agilidade)
	var roll = randf_range(0, chance)
	if roll >= 20:
		var dano = ((forca/2) * (roll / 20))
		print(dano)
		print(roll)
		return dano
	return 0

func ataque_P(agilInimigo : int):
	var chanceDeEsquiva = agilInimigo * 0.1
	var roll = randf_range(0, 10 + agilInimigo)
	if roll > 10:
		return 0
	return forca + (forca/2)

func defesa():
	overshield += vitalidade * 0.75
