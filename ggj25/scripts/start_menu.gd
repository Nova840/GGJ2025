extends Node
class_name StartMenu


@onready var players_label: Label = $PlayersLabel


func _ready() -> void:
	GameManager.reset()


func _process(delta: float) -> void:
	for p in range(-1, 4):
		if GameManager.get_input_action_1(p):
			GameManager.add_player(p)
		if GameManager.get_input_action_2(p):
			GameManager.remove_player(p)
		if GameManager.get_input_start_just_pressed(p):
			GameManager.next_round([])

	players_label.text = ""
	for p in GameManager.starting_players:
		players_label.text += str(p) + "\n"
