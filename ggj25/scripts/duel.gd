extends Node

var startup_delay: float = 1.75  # Wait 1.75 seconds before the game actually starts
var game_started: bool = false   # We'll flip this once the delay is over

var wait_time: float = 0.0       # How long until "FIRE!"
var reset_time: float = 4.0
var timer: float = 0.0           # Track elapsed time
var can_fire: bool = false       # Whether the player is allowed to fire
var difficulty: int = 3          # The higher this is, the shorter the reaction window
var reaction_window: float = 3   # Time window to succeed after "FIRE!"

func _ready() -> void:
	# We won't do any randomization or "Get ready!" messages yet.
	# We'll wait for the startup_delay to finish in _process().

	# Optionally, you can display some text or splash screen
	# indicating "Waiting to start..." or similar.
	print("Waiting 1.75 seconds to start...")

func _process(delta: float) -> void:
	# 1) First, handle the startup delay
	if not game_started:
		startup_delay -= delta
		if startup_delay <= 0.0:
			# Startup delay is over; let's start the duel
			game_started = true
			start_duel()
		# Exit here; we do nothing else during the startup wait
		return
	
	# 2) Once the game is started, run the duel logic as before
	var manager = $"/root/GameManager"  # or $"MyNode"

	if not can_fire:
		timer += delta
		
		# If user presses early, it's a loss
		if manager.get_input_action_1_just_pressed(-1):
			print("You fired too early! You lose!")
			reset_duel()
			return
		
		# Once wait_time is reached, "FIRE!"
		if timer >= wait_time:
			can_fire = true
			timer = 0.0
			$"Background".color = "#FFFFFF"
			print("FIRE!")
	else:
		timer += delta
		
		if manager.get_input_action_1_just_pressed(-1):
			if timer <= reaction_window:
				print("Success! You fired in time!")
				$"gunshot".play()
				$"Background".color = "#00FF00"
			else:
				print("Too late! You lose!")
				$"gunshot2".play()
				$"Background".color = "#FF0000"
			reset_duel()
			return
		
		if timer > reaction_window:
			print("Too late! You lose!")
			$"Background".color = "#FF0000"
			reset_duel()

func start_duel() -> void:
	# Move your original _ready logic here, so it runs after 1.75s
	randomize()
	# Randomly set the wait time
	wait_time = randf_range(4, 10)
	
	# Adjust reaction window based on difficulty
	reaction_window = 0.5 - (difficulty * 0.05)
	if reaction_window < 0.1:
		reaction_window = 0.1
	
	print("Get ready! Don't fire yet...")
	$"cock".play()
	$"Background".color = "#000000"

func reset_duel() -> void:
	timer = 0.0
	can_fire = false
	$"Background".color = "#000000"
	
	# Randomize wait_time again
	wait_time = randf_range(4, 10)
	print("Get ready! Don't fire yet...")
	$"cock".play()
