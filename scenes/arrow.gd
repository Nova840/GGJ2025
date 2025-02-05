extends Node2D
class_name Arrow


@onready var sprite: Sprite2D = $Sprite2D

@export var speed: float
@export var time_window: float

@export var up_texture: Texture2D
@export var down_texture: Texture2D
@export var left_texture: Texture2D
@export var right_texture: Texture2D

@export var up_texture_popped: Texture2D
@export var down_texture_popped: Texture2D
@export var left_texture_popped: Texture2D
@export var right_texture_popped: Texture2D

var arrow_spawner: ArrowSpawner

var time_created: float

var players_hit: Array[int]

var direction: Direction
enum Direction { Up, Down, Left, Right }


func _ready() -> void:
	time_created = Time.get_ticks_msec()
	if direction == Direction.Left:
		sprite.texture = left_texture
	elif direction == Direction.Right:
		sprite.texture = right_texture
	elif direction == Direction.Up:
		sprite.texture = up_texture
	elif direction == Direction.Down:
		sprite.texture = down_texture


func _process(delta: float) -> void:
	for p in GameManager.alive_players:
		var input: bool
		if direction == Direction.Left:
			input = GameManager.get_input_left_just_pressed(p)
		elif direction == Direction.Right:
			input = GameManager.get_input_right_just_pressed(p)
		elif direction == Direction.Up:
			input = GameManager.get_input_up_just_pressed(p)
		elif direction == Direction.Down:
			input = GameManager.get_input_down_just_pressed(p)
		if input and abs(time_created + 1500 - Time.get_ticks_msec()) / 1000 <= time_window:
			$"sfx".play()
			players_hit.append(p)
			sprite.top_level = true
			sprite.global_position = global_position
			if direction == Direction.Left:
				sprite.texture = left_texture_popped
			elif direction == Direction.Right:
				sprite.texture = right_texture_popped
			elif direction == Direction.Up:
				sprite.texture = up_texture_popped
			elif direction == Direction.Down:
				sprite.texture = down_texture_popped
			await get_tree().create_timer(0.1).timeout
			sprite.texture = null

	global_position.y -= speed * delta

	if (Time.get_ticks_msec() - 1500 - time_created) / 1000 >= 0.25:
		var players_to_eliminate := GameManager.alive_players.duplicate()
		for hit_player in players_hit:
			players_to_eliminate.remove_at(players_to_eliminate.find(hit_player))
		arrow_spawner.add_players_to_eliminated(players_to_eliminate)
