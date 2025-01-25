extends Node
class_name TestGame


@onready var rounds_label: Label = $RoundsLabel
@onready var time_label: Label = $TimeLabel

@export var game_time: float

var players_won: Array[int]
@onready var time_remaining: float = game_time


func _ready() -> void:
	rounds_label.text = str(GameManager.rounds_completed) + "\n\n"
	for p in GameManager.alive_players:
		rounds_label.text += str(p) + "\n"


func _process(delta: float) -> void:
	for p in GameManager.alive_players:
		if GameManager.get_input_action_1(p):
			players_won.append(p)

	time_remaining -= delta
	time_remaining = round(max(time_remaining, 0) * 100) / 100
	time_label.text = str(time_remaining)
	
	if time_remaining <= 0:
		var players_eliminated: Array[int]
		for p in GameManager.alive_players:
			if not players_won.has(p):
				players_eliminated.append(p)
		GameManager.finish_game(players_eliminated)
