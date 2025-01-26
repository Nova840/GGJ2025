extends Node


@export_file var game_scene_paths: Array[String]
@export var dont_repeat_rounds: int

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
var all_game_scenes_loaded: Array[String]


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


func get_input_up(player_controller: int) -> bool:
	if player_controller < 0:
		return Input.is_action_pressed("Keyboard Up")
	else:
		return Input.is_action_pressed("Joypad " + str(player_controller) + " Up")


func get_input_up_just_pressed(player_controller: int) -> bool:
	if player_controller < 0:
		return Input.is_action_just_pressed("Keyboard Up")
	else:
		return Input.is_action_just_pressed("Joypad " + str(player_controller) + " Up")


func get_input_down(player_controller: int) -> bool:
	if player_controller < 0:
		return Input.is_action_pressed("Keyboard Down")
	else:
		return Input.is_action_pressed("Joypad " + str(player_controller) + " Down")


func get_input_down_just_pressed(player_controller: int) -> bool:
	if player_controller < 0:
		return Input.is_action_just_pressed("Keyboard Down")
	else:
		return Input.is_action_just_pressed("Joypad " + str(player_controller) + " Down")


func get_input_left(player_controller: int) -> bool:
	if player_controller < 0:
		return Input.is_action_pressed("Keyboard Left")
	else:
		return Input.is_action_pressed("Joypad " + str(player_controller) + " Left")


func get_input_left_just_pressed(player_controller: int) -> bool:
	if player_controller < 0:
		return Input.is_action_just_pressed("Keyboard Left")
	else:
		return Input.is_action_just_pressed("Joypad " + str(player_controller) + " Left")


func get_input_right(player_controller: int) -> bool:
	if player_controller < 0:
		return Input.is_action_pressed("Keyboard Right")
	else:
		return Input.is_action_pressed("Joypad " + str(player_controller) + " Right")


func get_input_right_just_pressed(player_controller: int) -> bool:
	if player_controller < 0:
		return Input.is_action_just_pressed("Keyboard Right")
	else:
		return Input.is_action_just_pressed("Joypad " + str(player_controller) + " Right")


func next_round(players_eliminated: Array[int]) -> void:
	for p in players_eliminated:
		if alive_players.has(p):
			alive_players.remove_at(alive_players.find(p))
			round_player_eliminated[p] = rounds_completed

	rounds_completed += 1

	if alive_players.is_empty():
		get_tree().change_scene_to_file("res://scenes/end_screen.tscn")
	else:
		var scenes := game_scene_paths.duplicate()
		for i in dont_repeat_rounds:
			if all_game_scenes_loaded.is_empty():
				break
			var scene_index_to_remove := scenes.find(all_game_scenes_loaded[all_game_scenes_loaded.size() - 1])
			if scene_index_to_remove != -1:
				scenes.remove_at(scene_index_to_remove)
		if scenes.is_empty():
			scenes = game_scene_paths.duplicate()
		var scene_to_load: String = scenes[randi_range(0, scenes.size() - 1)]
		all_game_scenes_loaded.append(scene_to_load)
		get_tree().change_scene_to_file(scene_to_load)


func reset() -> void:
	rounds_completed = -1
	alive_players = starting_players.duplicate()
	for p in round_player_eliminated.keys():
		round_player_eliminated[p] = -1
	all_game_scenes_loaded.clear()


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
