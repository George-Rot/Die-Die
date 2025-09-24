extends CharacterBody2D
class_name PlayerController

@onready var sprite = $AnimatedSprite2D

@export var speed: float = 200.0
var can_battle = true  # Prevent multiple battle triggers

func _ready():
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
			# Trigger battle scene transition
			get_tree().call_deferred("change_scene_to_file", "res://scenes/batalha_slime.tscn")

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
