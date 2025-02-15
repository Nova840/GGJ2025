extends Node


# ----- CONFIG -----
var difficulty: int = 1           # Each difficulty level increases BPM by 10%
var base_bpm: float = 160.0       # Starting BPM
var rounds_to_play: int = 3       # Number of rounds in Simon
var time_per_input: float = 1.25  # How long the player has to press each direction
var startup_delay: float = 1.75   # Wait before starting the game
var round_delay: float = 0.0      # Delay between rounds
var initial_round_delay: float = 2.0      # Delay before initial rounds

# Directions that can appear
var possible_directions = ["up", "down", "left", "right"]

# ----- INTERNAL STATE -----
var simon_sequence: Array[String] = []           # The generated directions
var current_round: int = 0
var is_showing_sequence: bool = false
var is_player_input_phase: bool = false
var sequence_index: Array[int]
var show_sequence_index: int = 0
var bpm_timer: float = 0.0
var beat_duration: float = 0.0
var game_started: bool = false
var round_start_time: float

var players_lost: Array[int] = []
var players_finished: Array[int] = []

func _ready() -> void:
	# Calculate BPM for the given difficulty
	var current_bpm = base_bpm * pow(1.1, float(difficulty - 1))
	beat_duration = 60.0 / current_bpm
	difficulty = GameManager.rounds_completed/5
	randomize()

	for i in GameManager.alive_players.size():
		sequence_index.append(0)

	$beat.play()


func _process(delta: float) -> void:
	if not game_started:
		startup_delay -= delta
		if startup_delay <= 0:
			game_started = true
			start_next_round(true)
		return

	if is_showing_sequence:
		show_sequence_update(delta)
		return

	if is_player_input_phase:
		check_player_input(delta)


func start_next_round(is_first_round: bool = false) -> void:
	if not is_first_round:
		for p in GameManager.alive_players:
			if not players_finished.has(p) and not players_lost.has(p):
				players_lost.append(p)
		players_finished.clear()

	if current_round >= rounds_to_play or players_lost.size() == GameManager.alive_players.size():
		GameManager.next_round(players_lost)
		return

	current_round += 1
	for x in range(2 + (max(0, difficulty - 2))):
		simon_sequence.append(possible_directions[randi() % possible_directions.size()])

	var delay_time := initial_round_delay if is_first_round else round_delay
	if delay_time > 0:
		await delay(delay_time)

	is_showing_sequence = true
	is_player_input_phase = false
	for i in sequence_index.size():
		sequence_index[i] = 0
	bpm_timer = 0.0


func show_sequence_update(delta: float) -> void:
	bpm_timer += delta
	if bpm_timer >= beat_duration:
		bpm_timer = 0.0
		var direction = simon_sequence[show_sequence_index]
		flash_arrow(direction, 0.3)
		show_sequence_index += 1
		if show_sequence_index >= simon_sequence.size():
			is_showing_sequence = false
			is_player_input_phase = true
			round_start_time = Time.get_ticks_msec() / 1000.0
			show_sequence_index = 0


func check_player_input(delta: float) -> void:
	var round_time := simon_sequence.size() * time_per_input
	if round_start_time + round_time < Time.get_ticks_msec() / 1000.0:
		is_player_input_phase = false
		start_next_round()

	for i in GameManager.alive_players.size():
		var player := GameManager.alive_players[i]
		if players_finished.has(player) or players_lost.has(player):
			continue
		if GameManager.get_input_up_just_pressed(player):
			verify_input(player, i, "up")
		elif GameManager.get_input_down_just_pressed(player):
			verify_input(player, i, "down")
		elif GameManager.get_input_left_just_pressed(player):
			verify_input(player, i, "left")
		elif GameManager.get_input_right_just_pressed(player):
			verify_input(player, i, "right")


func verify_input(player: int, player_index: int, direction: String) -> void:
	var index := sequence_index[player_index]
	var correct_direction := simon_sequence[index] if index < simon_sequence.size() else ""
	if direction == correct_direction:
		sequence_index[player_index] += 1
		flash_arrow(direction, 0.2)
		if sequence_index[player_index] >= simon_sequence.size():
			players_finished.append(player)
	else:
		game_over(player)


func game_over(player: int) -> void:
	if players_finished.has(player):
		return
	$goof.play()
	if not players_lost.has(player):
		players_lost.append(player)
	players_finished.append(player)


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
	beat_duration = 60.0 / current_bpm

	# Play the beat sound
	$beat.play()

	# Wait for the next beat
	await get_tree().create_timer(beat_duration).timeout
