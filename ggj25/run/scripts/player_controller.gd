extends CharacterBody2D
class_name PlayerController

@export var speed = 10.0
@export var jump_power = 10.0

var speed_multiplier = 30.0
var jump_multiplier = -30.0
var direction = 0

var is_alive = true
var finished_level = false

var id = -1

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		
	var direction_vec = GameManager.get_input_move(id)
	
	if direction_vec.y < 0 and is_on_floor():
		velocity.y = jump_power * jump_multiplier
	
	direction = direction_vec.x
	if direction:
		velocity.x = direction * speed * speed_multiplier
	else:
		velocity.x = move_toward(velocity.x, 0, speed * speed_multiplier)
	
	move_and_slide()
