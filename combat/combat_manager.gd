extends Node
class_name CombatManager

signal combat_started(player, enemies:Array)
signal turn_started(who:Node)
signal action_resolved(data:Dictionary)
signal combat_ended(victory:bool)

var player:Player
var enemies:Array[Enemy] = []
var turn_queue:Array[Node] = []

# efeitos temporários simples
var slow_turns:Dictionary = {} # target_id -> remaining_turns (reduz agilidade em 50%)

func start(player_ref:Player, enemies_list:Array[Enemy]):
	player = player_ref
	enemies = enemies_list
	turn_queue.clear()
	turn_queue.append(player)
	for e in enemies:
		turn_queue.append(e)
	emit_signal("combat_started", player, enemies)
	_next_turn()

func _next_turn():
	if !combat_ended: #se o combate acabou, termina
		emit_signal("combat_ended", enemies.is_empty())
		return
	var who = turn_queue.pop_front()
	turn_queue.append(who)
	emit_signal("turn_started", who)
	# a UI/Controller deve chamar perform_* de acordo com a escolha do jogador

func perform_player_action(action:int):
		return null
