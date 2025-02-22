extends Node
class_name EndScreen


@onready var players_label: Label = $PlayersLabel
@onready var vertical_container: VBoxContainer = $VBoxContainer

var winners_sorted: Array[int]


func _ready() -> void:
	winners_sorted = GameManager.starting_players.duplicate()
	winners_sorted.sort_custom(func(player_a: int, player_b: int):
		return GameManager.round_player_eliminated[player_a] > GameManager.round_player_eliminated[player_b]
	)
	
	var offset = 0
	for p in winners_sorted:
		var starting_idx := GameManager.starting_players.find(p)
		players_label.text += "Player " + str(starting_idx + 1) + ": " + str(GameManager.round_player_eliminated[p]) + "\n"
		var player_texture := GameManager.PLAYER_SPRITES[starting_idx]
		var player_sprite: Sprite2D = Sprite2D.new()
		player_sprite.texture = player_texture
		player_sprite.scale = Vector2(0.05, 0.05)
		player_sprite.global_position.y += offset
		offset += 60
		vertical_container.add_child(player_sprite)


func _process(delta: float) -> void:
	for p in range(-1, 4):
		if GameManager.get_input_start_just_pressed(p):
			get_tree().change_scene_to_file("res://scenes/start_menu.tscn")
