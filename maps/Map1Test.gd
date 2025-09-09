extends Node2D

@onready var player = $Player
@onready var enemy = $Enemy
@onready var walls = $Walls

func _ready():
	print("Map1Test: Game iniciado!")
	print("Player e Enemy estão configurados com animações e movimentação!")
	print("Sistema de colisões ativo: Player e Enemy colidem com as paredes!")
	print("Sistema de batalha: Encoste no enemy para iniciar batalha!")
	print("Use WASD ou setas para mover o player")
	print("O enemy se move automaticamente e rebate nas paredes")
	
	# Reset battle trigger when returning from battle
	if player.has_method("reset_battle_trigger"):
		player.call("reset_battle_trigger")
