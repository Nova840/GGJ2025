extends Node2D
class_name ArrowSpawner


@onready var arrow_receptor_left: Node2D = $"../Arrow Receptors/Arrow Receptor LEFT"
@onready var arrow_receptor_right: Node2D = $"../Arrow Receptors/Arrow Receptor RIGHT"
@onready var arrow_receptor_up: Node2D = $"../Arrow Receptors/Arrow Receptor UP"
@onready var arrow_receptor_down: Node2D = $"../Arrow Receptors/Arrow Receptor DOWN"

@onready var all_arrow_receptors: Array[Node2D] = [
	arrow_receptor_left,
	arrow_receptor_right,
	arrow_receptor_up,
	arrow_receptor_down
]

@export var arrow: PackedScene

@export var spawn_distance: float

@export var round_time: float

var elapsed_time: float = 0

var players_lost: Array[int]

var beats: int = 0

func _ready() -> void:
	MusicPlayer.beat.connect(spawn_arrow)


func _process(delta: float) -> void:
	elapsed_time += delta
	if elapsed_time >= round_time:
		GameManager.next_round(players_lost)


func spawn_arrow() -> void:
	beats += 1
	if beats % 2 == 1: return
	var spawn_receptor := all_arrow_receptors[randi_range(0, all_arrow_receptors.size() - 1)]
	var arrow_instantiated := arrow.instantiate() as Arrow
	arrow_instantiated.global_position = spawn_receptor.global_position
	arrow_instantiated.global_position.y += spawn_distance
	arrow_instantiated.arrow_spawner = self

	if spawn_receptor == arrow_receptor_left:
		arrow_instantiated.direction = Arrow.Direction.Left
	elif spawn_receptor == arrow_receptor_right:
		arrow_instantiated.direction = Arrow.Direction.Right
	elif spawn_receptor == arrow_receptor_up:
		arrow_instantiated.direction = Arrow.Direction.Up
	elif spawn_receptor == arrow_receptor_down:
		arrow_instantiated.direction = Arrow.Direction.Down

	add_child(arrow_instantiated)


func add_players_to_eliminated(players: Array[int]):
	for p in players:
		if not players_lost.has(p):
			players_lost.append(p)
