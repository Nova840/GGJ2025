extends Node


@export_file var game_scene_paths: Array[String]

var rounds_completed: int = 0
var alive_players: Array[int] = [-1, 0]


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
		return Input.get_action_strength("Keyboard Action 1") >= 1
	else:
		return Input.get_action_strength("Joypad " + str(player_controller) + " Action 1") >= 1


func get_input_action_2(player_controller: int) -> bool:
	if player_controller < 0:
		return Input.get_action_strength("Keyboard Action 2") >= 1
	else:
		return Input.get_action_strength("Joypad " + str(player_controller) + " Action 2") >= 1


func finish_game(players_eliminated: Array[int]) -> void:
	rounds_completed += 1
	for p in players_eliminated:
		if alive_players.has(p):
			alive_players.remove_at(alive_players.find(p))
	get_tree().change_scene_to_file(game_scene_paths[randi_range(0, game_scene_paths.size() - 1)])
