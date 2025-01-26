extends Node2D
class_name PlayerAnimator

@export var player_controller: PlayerController
@export var sprite: Sprite2D

func _process(delta: float) -> void:
	if player_controller.direction == 1:
		sprite.rotation_degrees += 10
	elif player_controller.direction == -1:
		sprite.rotation_degrees -= 10
	
	if not player_controller.is_alive or player_controller.finished_level:
		sprite.visible = false
