extends AudioStreamPlayer

var round_count: int = 250
var manager                       # Reference to your input manager node

func _ready() -> void:
	# Start normal speed
	pitch_scale = 1.0
	if (get_meta("bpm160")):
		pitch_scale = 140/160
	play()
	
func _process(delta: float) -> void:
	var manager = $"/root/GameManager"  # or $"MyNode"
	if manager.get_input_action_1_just_pressed(-1):
		on_round_end()


func on_round_end() -> void:
	round_count += 1

	# Every 5 rounds, raise playback speed by 10%
	if round_count % 5 == 0:
		var new_speed = pitch_scale * 1.1  # Speed up by 10%
		pitch_scale = new_speed

		# Now invert that factor in the bus's AudioEffectPitchShift to restore original pitch
		var bus_name = "Master"  # Or whichever bus you're using
		var bus_index = AudioServer.get_bus_index(bus_name)
		
		# Assuming your PitchShift effect is the *first* effect in that bus (index 0)
		var effect = AudioServer.get_bus_effect(bus_index, 0)
		if effect is AudioEffectPitchShift:
			var pitch_shift_effect = effect as AudioEffectPitchShift
			pitch_shift_effect.pitch_scale = 1.0 / new_speed
		print("Speeding up!")


func _on_finished() -> void:
	play()
	pass # Replace with function body.
