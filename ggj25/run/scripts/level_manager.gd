extends Node2D
class_name LevelManager

var starting_players: Array[int]
var player_controllers: Array[PlayerController]


func _init() -> void:
	# spawn player sprites
	starting_players = GameManager.alive_players
	print("starting players : " + str(starting_players.size()))
	
	var start_pos_offset = 0
	for p in starting_players:
		var player_scene: PlayerController = preload("res://run/scenes/player.tscn").instantiate()
		add_child(player_scene)
		player_scene.id = p
		player_scene.global_position.x = 20 + start_pos_offset
		player_scene.global_position.y = 300
		# increase offset for other players
		start_pos_offset += 5
		player_controllers.append(player_scene)
		
		# load sprites dynamically
		var animator: PlayerAnimator = player_scene.get_child(0)
		var alive_index = GameManager.starting_players.find(p)
		animator.sprite.texture = GameManager.PLAYER_SPRITES[alive_index]


func _process(delta: float) -> void:
	# check if players which players won or got eliminated
	var players_won: Array[int]
	var players_eliminated: Array[int]
	for p in player_controllers:
		if not p.is_alive and not p.finished_level:
			players_eliminated.append(_controller_to_id(p))
		if p.finished_level:
			players_won.append(_controller_to_id(p))
			# TODO - remove player visibility
	
	# if all alive players have made it to the goal, move on to the next level
	if players_eliminated.size() + players_won.size() == starting_players.size():
		GameManager.next_round(players_eliminated)


func _controller_to_id(p: PlayerController) -> int:
	var p_index = player_controllers.find(p)
	var p_id = starting_players[p_index]
	return p_id
