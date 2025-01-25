extends Node


@export_file var game_scene_paths: Array[String]

const PLAYER_SPRITES: Array[Resource] = [
	preload("res://assets/Blue Bubble .png"),
	preload("res://assets/Green Bubble .png"),
	preload("res://assets/Pink Bubble .png"),
	preload("res://assets/Purple Bubble .png"),
]

var rounds_completed: int = -1
var starting_players: Array[int]
var alive_players: Array[int]
var round_player_eliminated: Dictionary # [int player, int round eliminated]


func get_input_move(player_controller: int) -> Vector2:
	if player_controller < 0:
		return Input.get_vector("Keyboard Left", "Keyboard Right", "Keyboard Up", "Keyboard Down")
	else:
		return Input.get_vector(
				"Joypad " + str(player_controller) + " Left", \
				"Joypad " + str(player_controller) + " Right", \
				"Joypad " + str(player_controller) + " Up", \
				"Joypad " + str(player_controller) + " Down", \
		)


func get_input_action_1(player_controller: int) -> bool:
	if player_controller < 0:
		return Input.is_action_pressed("Keyboard Action 1")
	else:
		return Input.is_action_pressed("Joypad " + str(player_controller) + " Action 1")


func get_input_action_1_just_pressed(player_controller: int) -> bool:
	if player_controller < 0:
		return Input.is_action_just_pressed("Keyboard Action 1")
	else:
		return Input.is_action_just_pressed("Joypad " + str(player_controller) + " Action 1")


func get_input_action_2(player_controller: int) -> bool:
	if player_controller < 0:
		return Input.is_action_pressed("Keyboard Action 2")
	else:
		return Input.is_action_pressed("Joypad " + str(player_controller) + " Action 2")


func get_input_action_2_just_pressed(player_controller: int) -> bool:
	if player_controller < 0:
		return Input.is_action_just_pressed("Keyboard Action 2")
	else:
		return Input.is_action_just_pressed("Joypad " + str(player_controller) + " Action 2")


func get_input_start(player_controller: int) -> bool:
	if player_controller < 0:
		return Input.is_action_pressed("Keyboard Start")
	else:
		return Input.is_action_pressed("Joypad " + str(player_controller) + " Start")


func get_input_start_just_pressed(player_controller: int) -> bool:
	if player_controller < 0:
		return Input.is_action_just_pressed("Keyboard Start")
	else:
		return Input.is_action_just_pressed("Joypad " + str(player_controller) + " Start")


func next_round(players_eliminated: Array[int]) -> void:
	for p in players_eliminated:
		if alive_players.has(p):
			alive_players.remove_at(alive_players.find(p))
			round_player_eliminated[p] = rounds_completed

	rounds_completed += 1

	if alive_players.size() == 0:
		get_tree().change_scene_to_file("res://scenes/end_screen.tscn")
	else:
		get_tree().change_scene_to_file(game_scene_paths[randi_range(0, game_scene_paths.size() - 1)])


func reset() -> void:
	rounds_completed = -1
	alive_players = starting_players.duplicate()
	for p in round_player_eliminated.keys():
		round_player_eliminated[p] = -1


func add_player(player: int) -> void:
	if not starting_players.has(player):
		starting_players.append(player)
	if not alive_players.has(player):
		alive_players.append(player)
	if not round_player_eliminated.has(player):
		round_player_eliminated[player] = -1


func remove_player(player: int) -> void:
	if starting_players.has(player):
		starting_players.remove_at(starting_players.find(player))
	if alive_players.has(player):
		alive_players.remove_at(alive_players.find(player))
	if round_player_eliminated.has(player):
		round_player_eliminated.erase(player)
