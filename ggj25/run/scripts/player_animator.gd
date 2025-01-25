extends Node2D

@export var player_controller: PlayerController
@export var animation_player: AnimationPlayer
@export var sprite: Sprite2D

func _process(delta: float) -> void:
	if player_controller.direction == 1:
		sprite.flip_h = false
	elif player_controller.direction == -1:
		sprite.flip_h = true
	
	if player_controller.is_on_floor() and abs(player_controller.velocity.x) > 0.0:
		animation_player.play("move")
	elif not player_controller.is_on_floor() and player_controller.velocity.y < 0.0:
		animation_player.play("jump")
	elif not player_controller.is_on_floor():
		animation_player.play("fall")
	else:
		animation_player.play("idle")
