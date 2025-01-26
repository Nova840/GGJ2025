extends Node

# ----- CONFIG -----
var difficulty: int = 1           # Each difficulty level increases BPM by 10%
var base_bpm: float = 160.0       # Starting BPM
var rounds_to_play: int = 3       # Number of rounds in Simon
var time_per_input: float = 2.0   # How long the player has to press each direction
var startup_delay: float = 1.75   # Optional: wait before starting

# Directions that can appear
var possible_directions = ["up", "down", "left", "right"]

# ----- INTERNAL STATE -----
var simon_sequence: Array = []    # The generated directions
var current_round: int = 0
var is_showing_sequence: bool = false
var is_player_input_phase: bool = false
var sequence_index: int = 0
var bpm_timer: float = 0.0
var beat_duration: float = 0.0
var game_started: bool = false

func _ready() -> void:
	# Calculate the BPM for the given difficulty
	# "Every difficulty up" => multiply by 1.1^(difficulty - 1)
	# e.g. difficulty=1 => BPM=160, difficulty=2 => BPM=176, etc.
	var current_bpm = base_bpm * pow(1.1, float(difficulty - 1))
	# Convert BPM to "seconds per beat" => 60/BPM
	beat_duration = 60.0 / current_bpm

	# Print a message or show some UI
	print("Simon Says game loaded. Difficulty:", difficulty)
	print("Current BPM:", current_bpm, "=> each beat is", beat_duration, "seconds.")
	print("Waiting for startup delay of", startup_delay, "seconds...")

func _process(delta: float) -> void:
	# 1) Handle startup delay if you want that feature
	if not game_started:
		startup_delay -= delta
		if startup_delay <= 0:
			game_started = true
			# Start the first round
			start_next_round()
		return

	# 2) If we are currently showing the sequence, handle timing
	if is_showing_sequence:
		show_sequence_update(delta)
		return

	# 3) If we are in the player's input phase, handle input
	if is_player_input_phase:
		# The player must press the correct directions in sequence
		check_player_input(delta)

func start_next_round() -> void:
	current_round += 1
	# Add one new random direction
	simon_sequence.append(possible_directions[randi() % possible_directions.size()])
	
	print("========================")
	print("Round", current_round, "/", rounds_to_play)
	print("Simon sequence so far:", simon_sequence)
	
	if current_round > rounds_to_play:
		# The player has successfully completed all rounds
		print("Congratulations! You completed all rounds!")
		# You can end the game or do something else
		set_process(false)
		return

	# Show the sequence to the player (one direction per beat)
	is_showing_sequence = true
	is_player_input_phase = false
	sequence_index = 0
	bpm_timer = 0.0
	print("Showing sequence...")

func show_sequence_update(delta: float) -> void:
	# We'll wait 'beat_duration' between each direction.
	bpm_timer += delta

	# Check if it's time to "show" the next direction in the sequence
	if bpm_timer >= beat_duration:
		bpm_timer = 0.0
		var direction = simon_sequence[sequence_index]
		# E.g., highlight a direction UI or print it out:
		print("SHOWING:", direction)
		highlight_direction(direction)

		sequence_index += 1
		if sequence_index >= simon_sequence.size():
			# We finished showing all directions this round
			is_showing_sequence = false
			is_player_input_phase = true
			sequence_index = 0
			print("Now it's your turn to input the directions!")
	
func highlight_direction(direction: String) -> void:
	# For real use: flash an arrow sprite, play sound, animate color, etc.
	# Here we just do a debug print.
	# E.g.:
	#   $UpArrow.flash() if direction == "up"
	pass

var input_timer: float = 0.0  # tracks how long the player has for the current step

func check_player_input(delta: float) -> void:
	# We are waiting for the player to press the next direction in 'simon_sequence'
	input_timer += delta
	if input_timer > time_per_input:
		# Player took too long
		print("TIME'S UP! You took too long!")
		game_over()
		return

	# If the player pressed something:
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
		# Correct!
		sequence_index += 1
		input_timer = 0.0  # reset timer for next input
		print("Correct input:", direction, "(", sequence_index, "/", simon_sequence.size(), ")")
		if sequence_index >= simon_sequence.size():
			# Player got the full sequence correct this round!
			print("Round", current_round, "complete!")
			# Move to next round
			is_player_input_phase = false
			start_next_round()
	else:
		# Wrong direction
		print("WRONG! You pressed", direction, "but expected", correct_direction, "!")
		game_over()

func game_over() -> void:
	print("GAME OVER. You made it to Round:", current_round)
	# Stop any further processing
	set_process(false)
