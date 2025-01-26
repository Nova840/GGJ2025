extends Node2D
class_name Arrow


@onready var sprite: Sprite2D = $Sprite2D

@export var speed: float
@export var time_window: float

var time_created: float

var players_hit: Array[int]

var direction: Direction
enum Direction { Up, Down, Left, Right }


func _ready() -> void:
	time_created = Time.get_ticks_msec()


func _process(delta: float) -> void:
	global_position.y -= speed * delta

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
		if input and abs(time_created + 1500 - Time.get_ticks_msec() ) / 1000 <= time_window:
			players_hit.append(p)
			sprite.texture = null
		
