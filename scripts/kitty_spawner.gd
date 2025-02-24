extends Control


@export var kitty_scene: PackedScene
@export var max_time_between_inputs: float = 1

enum Direction { Up, Down, Left, Right }
var combination: Array[Direction] = [
	Direction.Up,
	Direction.Up,
	Direction.Down,
	Direction.Down,
	Direction.Left,
	Direction.Right,
	Direction.Left,
	Direction.Right
]
var controller_combination: Array = [[], [], [], [], []]
var controller_time_since_press_direction: Array[float] = [0, 0, 0, 0, 0]


func _process(delta: float) -> void:
	for p in range(-1, 4):
		var i := p + 1

		controller_time_since_press_direction[i] += delta

		var direction: Direction
		if GameManager.get_input_up_just_pressed(p):
			direction = Direction.Up
		elif GameManager.get_input_down_just_pressed(p):
			direction = Direction.Down
		elif GameManager.get_input_left_just_pressed(p):
			direction = Direction.Left
		elif GameManager.get_input_right_just_pressed(p):
			direction = Direction.Right
		else:
			continue

		if controller_time_since_press_direction[i] >= max_time_between_inputs:
			controller_combination[i].clear()

		controller_time_since_press_direction[i] = 0

		controller_combination[i].append(direction)
		if controller_combination[i].size() > 8:
			controller_combination[i].remove_at(0)

		if compare_arrays(combination, controller_combination[i]):
			var kitty: Control = kitty_scene.instantiate()
			add_child(kitty)


func compare_arrays(array_1: Array, array_2: Array) -> bool:
	if array_1.size() != array_2.size():
		return false
	for i in array_1.size():
		if array_1[i] != array_2[i]:
			return false
	return true
