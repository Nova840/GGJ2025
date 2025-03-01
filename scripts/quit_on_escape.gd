extends Node


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Quit") and OS.get_name() != "Web":
		get_tree().quit()
