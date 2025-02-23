extends Sprite2D

var timer : float = 0.0
var move_interval : float = 1.0     # How often we pick a new vertical position
var lerp_speed : float = 0.05      # How fast we move to that position
var base_y : float = 0.0           # The starting y (so bobbing is around this)
var target_y : float = 0.0         # Where we want to move next
var bob_range : float = 10.0       # How far up/down to bob (e.g. +/- 10px)

func _ready() -> void:
	# Record the original y so we can bob around it
	base_y = position.y
	# Immediately choose a first target
	pick_new_target_location()

func _process(delta: float) -> void:
	timer += delta
	
	# When enough time passes, pick a fresh position
	if timer >= move_interval:
		pick_new_target_location()
		timer = 0.0
	
	# Smoothly lerp our y toward the chosen target
	position.y = lerp(position.y, target_y, lerp_speed)

func pick_new_target_location() -> void:
	# Pick a new y target around our original position within bob_range
	target_y = base_y + randf_range(-bob_range, bob_range)
