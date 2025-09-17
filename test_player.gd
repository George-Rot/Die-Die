extends Node

func _ready():
	print("=== TESTE DE INPUT ===")
	
func _input(event):
	if event is InputEventKey and event.pressed:
		print("Tecla pressionada: ", event.physical_keycode)
		if event.physical_keycode == KEY_W:
			print("W detectado!")
		elif event.physical_keycode == KEY_A:
			print("A detectado!")
		elif event.physical_keycode == KEY_S:
			print("S detectado!")
		elif event.physical_keycode == KEY_D:
			print("D detectado!")

func _process(_delta):
	if Input.is_action_pressed("move_up"):
		print("move_up action ativo!")
	if Input.is_action_pressed("move_down"):
		print("move_down action ativo!")
	if Input.is_action_pressed("move_left"):
		print("move_left action ativo!")
	if Input.is_action_pressed("move_right"):
		print("move_right action ativo!")
