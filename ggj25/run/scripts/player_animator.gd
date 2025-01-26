extends Node2D
class_name PlayerAnimator

@export var player_controller: PlayerController
@export var sprite: Sprite2D

func _process(delta: float) -> void:
	# TODO - on move rotate sprite
	if player_controller.direction == 1:
		sprite.flip_h = false
	elif player_controller.direction == -1:
		sprite.flip_h = true
	
	if not player_controller.is_alive:
		sprite.visible = false
