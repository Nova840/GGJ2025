extends Node2D

var starting_players: Array[int]
var player_controllers: Array[PlayerController]

func _init() -> void:
	# spawn player sprites
	var starting_players = GameManager.alive_players


func _process(delta: float) -> void:
	# check if players which players won or got eliminated
	var players_won: Array[int]
	var players_eliminated: Array[int]
	for p in player_controllers:
		if not p.is_alive:
			players_eliminated.append(_controller_to_id(p))
		if p.finished_level:
			players_won.append(_controller_to_id(p))
	
	# if all alive players have made it to the goal, move on to the next level
	if players_eliminated.size() + players_won.size() == starting_players.size():
		GameManager.next_round(players_eliminated)


func _controller_to_id(p: PlayerController) -> int:
	var p_index = player_controllers.find(p)
	var p_id = starting_players[p_index]
	return p_id
