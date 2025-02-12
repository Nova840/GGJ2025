extends Node
class_name StartMenu

@onready var player_1_label: Label = $Player1Label
@onready var player_2_label: Label = $Player2Label
@onready var player_3_label: Label = $Player3Label
@onready var player_4_label: Label = $Player4Label
@onready var start_label = $StartLabel


func _ready() -> void:
	GameManager.reset()
	start_label.visible = false


func _process(delta: float) -> void:
	var has_player := GameManager.starting_players.size() > 0

	for p in range(-1, 4):
		if GameManager.get_input_action_1(p):
			GameManager.add_player(p)
		if GameManager.get_input_action_2(p):
			GameManager.remove_player(p)
		if GameManager.get_input_start_just_pressed(p) and has_player:
			GameManager.next_round([])

	if has_player != start_label.visible:
		start_label.visible = has_player
