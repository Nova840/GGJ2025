extends Label

var timer: Timer
var tween: Tween

func _ready() -> void:
	# Center the RichTextLabel on the screen

	# Add a Tween node dynamically for the popping effect
	tween = create_tween()

	pivot_offset = size/2

	# Start the popping animation
	scale = Vector2.ZERO  # Start from zero scale
	tween.tween_property(self, "scale", Vector2.ONE, 1.5)

	# Add a Timer node dynamically to handle the disappearance
	timer = Timer.new()
	timer.wait_time = 1.75  # Set the timer for 1 second
	timer.one_shot = true  # Run the timer only once
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	add_child(timer)

	# Start the timer
	timer.start()

func _on_timer_timeout() -> void:
	# Hide the label after 1 second
	hide()
