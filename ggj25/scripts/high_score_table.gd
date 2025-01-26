extends Control
class_name HighScoreTable


static var high_scores: Array[int]

@onready var scores_label: Label = $TextureRect/ScoresLabel

@export var is_end_screen: bool = false


func _ready() -> void:
	if is_end_screen:
		for p in GameManager.starting_players:
			var score: int = GameManager.round_player_eliminated[p]
			high_scores.append(score)
	
	high_scores.sort()
	high_scores.reverse()
	scores_label.text = ""
	for score in high_scores.slice(0, 9):
		scores_label.text += str(score) + "\n"
