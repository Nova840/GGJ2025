extends Node

# ----- CONFIG -----
var difficulty: int = 1           # Each difficulty level increases BPM by 10%
var base_bpm: float = 160.0       # Starting BPM
var rounds_to_play: int = 3       # Number of rounds in Simon
var time_per_input: float = 2.0   # How long the player has to press each direction
var startup_delay: float = 1.75   # Wait before starting the game
var round_delay: float = 2.0      # Delay between rounds

# Directions that can appear
var possible_directions = ["up", "down", "left", "right"]

# ----- INTERNAL STATE -----
var simon_sequence = []           # The generated directions
var current_round: int = 0
var is_showing_sequence: bool = false
var is_player_input_phase: bool = false
var sequence_index: int = 0
var bpm_timer: float = 0.0
var beat_duration: float = 0.0
var game_started: bool = false
var music

var input_timer: float = 0.0      # Tracks how long the player has for the current step

func _ready() -> void:
	# Calculate BPM for the given difficulty
	var current_bpm = base_bpm * pow(1.1, float(difficulty - 1))
	beat_duration = 60.0 / current_bpm

	randomize()
	print("Simon Says game loaded. Difficulty:", difficulty)
	print("Current BPM:", current_bpm, "=> each beat is", beat_duration, "seconds.")
	print("Waiting for startup delay of", startup_delay, "seconds...")
	
	music = $"/root/MusicPlayer"
	music.stop()
	$beat.play()

func _process(delta: float) -> void:
	if not game_started:
		startup_delay -= delta
		if startup_delay <= 0:
			game_started = true
			start_next_round()
		return

	if is_showing_sequence:
		show_sequence_update(delta)
		return

	if is_player_input_phase:
		check_player_input(delta)

func start_next_round() -> void:
	if current_round >= rounds_to_play:
		print("Congratulations! You completed all rounds!")
		set_process(false)
		return

	current_round += 1
	for x in range(2 + (max(0, difficulty-2))):
		simon_sequence.append(possible_directions[randi() % possible_directions.size()])

	print("========================")
	print("Round", current_round, "/", rounds_to_play)
	print("Simon sequence so far:", simon_sequence)

	print("Waiting 2 seconds before starting the next round...")
	await delay(round_delay)

	is_showing_sequence = true
	is_player_input_phase = false
	sequence_index = 0
	bpm_timer = 0.0
	print("Showing sequence...")

func show_sequence_update(delta: float) -> void:
	bpm_timer += delta
	if bpm_timer >= beat_duration:
		bpm_timer = 0.0
		var direction = simon_sequence[sequence_index]
		print("SHOWING:", direction)
		flash_arrow(direction, 0.3)
		sequence_index += 1
		if sequence_index >= simon_sequence.size():
			is_showing_sequence = false
			is_player_input_phase = true
			sequence_index = 0
			input_timer = 0.0
			print("Now it's your turn to input the directions!")

func check_player_input(delta: float) -> void:
	input_timer += delta
	if input_timer > time_per_input:
		print("TIME'S UP! You took too long!")
		game_over()
		return

	if Input.is_action_just_pressed("ui_up"):
		verify_input("up")
	elif Input.is_action_just_pressed("ui_down"):
		verify_input("down")
	elif Input.is_action_just_pressed("ui_left"):
		verify_input("left")
	elif Input.is_action_just_pressed("ui_right"):
		verify_input("right")

func verify_input(direction: String) -> void:
	var correct_direction = simon_sequence[sequence_index]
	if direction == correct_direction:
		sequence_index += 1
		input_timer = 0.0
		print("Correct input:", direction)
		flash_arrow(direction, 0.2)
		if sequence_index >= simon_sequence.size():
			is_player_input_phase = false
			start_next_round()
	else:
		print("WRONG! You pressed", direction)
		
		game_over()

func game_over() -> void:
	print("GAME OVER. You made it to Round:", current_round)
	$goof.play()
	set_process(false)

func flash_arrow(direction: String, flash_time: float = 0.3) -> void:
	var arrow_node = get_arrow_node(direction)
	if not arrow_node:
		return
	arrow_node.visible = true
	$sfx.play()
	var timer = Timer.new()
	timer.wait_time = flash_time
	timer.one_shot = true
	add_child(timer)
	timer.start()
	await timer.timeout
	arrow_node.visible = false
	timer.queue_free()

func delay(seconds: float) -> void:
	var timer = Timer.new()
	timer.wait_time = seconds
	timer.one_shot = true
	add_child(timer)
	timer.start()
	await timer.timeout
	timer.queue_free()

func get_arrow_node(direction: String) -> Node:
	match direction:
		"up": return $"Arrows_Flash/Up"
		"down": return $"Arrows_Flash/Down"
		"left": return $"Arrows_Flash/Left"
		"right": return $"Arrows_Flash/Right"
		_: return null

func _on_finished() -> void:
	# Calculate beat duration based on current BPM
	var current_bpm = base_bpm * pow(1.1, float(difficulty - 1))
	var beat_duration = 60.0 / current_bpm

	# Play the beat sound
	$beat.play()

	# Wait for the next beat
	await get_tree().create_timer(beat_duration).timeout
