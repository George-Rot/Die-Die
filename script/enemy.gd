extends CharacterBody2D
class_name Enemy

@onready var sprite = $AnimatedSprite2D

var speed = 50
var direction = Vector2.RIGHT
var change_timer = 0.0
var change_interval = 2.0

func _ready():
	sprite.play("default")
	randomize()

func _physics_process(delta):
	handle_movement(delta)
	handle_animation()

func handle_movement(delta):
	# Update direction change timer
	change_timer += delta
	
	# Change direction randomly every interval
	if change_timer >= change_interval:
		change_timer = 0.0
		var random_angle = randf() * 2 * PI
		direction = Vector2(cos(random_angle), sin(random_angle)).normalized()
		change_interval = randf_range(1.5, 3.0)  # Random interval
	
	# Set velocity for physics movement
	velocity = direction * speed
	
	# Use move_and_slide() for automatic collision detection
	move_and_slide()
	
	# Check if collided with wall and change direction
	if get_slide_collision_count() > 0:
		var collision = get_slide_collision(0)
		direction = direction.bounce(collision.get_normal())
		change_timer = change_interval  # Force direction change

func handle_animation():
	# Flip sprite based on movement direction
	if direction.x > 0:
		sprite.flip_h = false
	elif direction.x < 0:
		sprite.flip_h = true
