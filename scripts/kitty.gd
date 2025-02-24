extends TextureRect


@export var move_speed: float
@export var rotate_speed: float


func _ready() -> void:
	await get_tree().create_timer(10).timeout
	queue_free()


func _process(delta: float) -> void:
	position += Vector2(-move_speed, 0) * delta
	rotation_degrees += rotate_speed * delta
