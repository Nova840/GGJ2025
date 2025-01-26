extends Label
class_name StartPlayerLabel

@export var player_index: int

var no_player_text: String


func _ready() -> void:
	no_player_text = text
	set_label_text()


func _process(delta: float) -> void:
	set_label_text()


func set_label_text() -> void:
	if GameManager.starting_players.size() <= player_index:
		text = no_player_text
	else:
		var player: int = GameManager.starting_players[player_index]
		if player < 0:
			text = "Keyboard"
		else:
			text = "Controller " + str(player + 1)
