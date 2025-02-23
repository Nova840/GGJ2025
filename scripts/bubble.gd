extends Sprite2D

var timer : float = 0.0
var scale_interval : float = 1.0           # How often to pick a new random scale
var target_scale : Vector2 = Vector2(1,1)  # Current scale target
var lerp_speed : float = 0.05             # How fast to lerp toward the new scale

func _ready() -> void:
	# Initialize a random target scale when ready
	pick_new_target_scale()

func _process(delta: float) -> void:
	# Update rotation (optional, remove if not needed)
	rotation += 0.01
	
	# Update timer
	timer += delta
	
	# If it's time, pick a new target scale
	if timer >= scale_interval:
		pick_new_target_scale()
		timer = 0.0
	
	# Lerp toward the target scale to smooth out the growth/shrink
	global_scale = global_scale.lerp(target_scale, lerp_speed)

func pick_new_target_scale() -> void:
	var random_size = randf_range(1.0, 1.2)
	target_scale = Vector2(random_size, random_size)
