extends Node

var wait_time: float = 0.0       # How long until "FIRE!"
var reset_time: float = 4.0
var timer: float = 0.0          # Track elapsed time
var can_fire: bool = false      # Whether the player is allowed to fire
var difficulty: int = 3         # The higher this is, the shorter the reaction window
var reaction_window: float = 3  # Time window to succeed after "FIRE!"

func _ready() -> void:
	randomize()
	# Randomly set the wait time before "FIRE!" is displayed
	wait_time = randf_range(4, 10)
	
	# Adjust reaction window based on difficulty
	# (shorter window = harder)
	reaction_window = 0.5 - (difficulty * 0.05)
	if reaction_window < 0.1:
		reaction_window = 0.1  # Ensure there's always *some* window
	
	# Show some sort of "Get Ready..." message (if you have a label or UI)
	print("Get ready! Don't fire yet...")
	$"cock".play()
	$"Background".color = "#000000"

func _process(delta: float) -> void:
	# If we're still waiting to show "FIRE!", count down
	var manager = $"/root/GameManager" # or $"MyNode"
	if not can_fire:
		timer += delta
		
		# Before the duel has "started", if user presses Space, they fired too early
		if manager.get_input_action_1_just_pressed(-1):
			print("You fired too early! You lose!")
			# Reset or handle loss state here
			reset_duel()
			return
		
		# If the wait time is over, signal "FIRE!"
		if timer >= wait_time:
			can_fire = true
			timer = 0.0
			$"Background".color = "#FFFFFF"
			print("FIRE!")
	else:
		# The duel is active and the player must react within the reaction_window
		timer += delta
		
		if manager.get_input_action_1_just_pressed(-1):
			# The user fired in time
			if timer <= reaction_window:
				print("Success! You fired in time!")
				$"gunshot".play()
				$"Background".color = "#00FF00"
			else:
				$"gunshot2".play()
				print("Too late! You lose!")
				$"Background".color = "#FF0000"
			reset_duel()
			return
		
		# If they haven't pressed and the window passed, they lose
		if timer > reaction_window:
			print("Too late! You lose!")
			$"Background".color = "#FF0000"
			reset_duel()

func reset_duel() -> void:
	# Reset variables if you want to replay quickly
	timer = 0.0
	$"Background".color = "#000000"
	timer = 0.0
	can_fire = false
	# Re-randomize wait_time or keep it as is, depending on your design
	wait_time = randf_range(4, 10)
