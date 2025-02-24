extends Control
class_name HighScoreTable

var high_scores: Array[int]

@onready var scores_label: Label = $Container/ScoresLabel

@export var is_end_screen: bool = false

var high_scores_file_path: String = "user://high_scores.dat"


func _ready() -> void:
	load_high_scores()

	if is_end_screen:
		for p in GameManager.starting_players:
			var score: int = GameManager.round_player_eliminated[p]
			high_scores.append(score)

	high_scores.sort()
	high_scores.reverse()

	scores_label.text = ""
	for i in 10:
		if i < high_scores.size():
			scores_label.text += str(high_scores[i]) + "\n"
		else:
			scores_label.text += "-\n"

	save_high_scores()


func load_high_scores() -> void:
	var file = FileAccess.open(high_scores_file_path, FileAccess.ModeFlags.READ)
	if file:
		# Read each line and append the score to the high_scores array
		while not file.eof_reached():
			var line := file.get_line().strip_edges()
			if not line.is_valid_int():
				continue
			var score = int(line)
			high_scores.append(score)
		file.close()


func save_high_scores() -> void:
	var file = FileAccess.open(high_scores_file_path, FileAccess.ModeFlags.WRITE)
	if file:
		for score in high_scores:
			file.store_line(str(score))
		file.close()
