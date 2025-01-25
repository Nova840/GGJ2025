extends Node
class_name EndScreen


@onready var players_label: Label = $PlayersLabel

var winners_sorted: Array[int]


func _ready() -> void:
	winners_sorted = GameManager.starting_players.duplicate()
	winners_sorted.sort_custom(func(player_a: int, player_b: int):
		return GameManager.round_player_eliminated[player_a] > GameManager.round_player_eliminated[player_b]
	)
	
	for p in winners_sorted:
		players_label.text += str(p) + ":" + str(GameManager.round_player_eliminated[p]) + "\n"
