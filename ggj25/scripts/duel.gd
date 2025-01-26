extends Node
var gunfire_texture = preload("res://assets/Duel_Gun_Fire_Animation .png")

var startup_delay: float = 1.75  # Wait 1.75 seconds before the game actually starts
var game_started: bool = false   # We'll flip this once the delay is over
var music 
var synths
var bass1
var bass2
var wait_time: float = 0.0       # How long until "FIRE!"
var reset_time: float = 4.0
var timer: float = 0.0           # Track elapsed time
var can_fire: bool = false       # Whether the player is allowed to fire
var difficulty: int = 0          # The higher this is, the shorter the reaction window
var reaction_window: float = 8.0   # Time window to succeed after "FIRE!"
var prefired = false

func _ready() -> void:
	# We won't do any randomization or "Get ready!" messages yet.
	# We'll wait for the startup_delay to finish in _process().

	# Optionally, you can display some text or splash screen
	# indicating "Waiting to start..." or similar.
	print("Waiting 1.75 seconds to start...")

func _process(delta: float) -> void:
	# 1) First, handle the startup delay
	music = $"/root/MusicPlayer"
	synths = $"/root/MusicPlayer/160 to 140"
	bass1 = $"/root/MusicPlayer/160 to 141"
	bass2 = $"/root/MusicPlayer/160 to 142"
	
	if not game_started:
		synths.stop()
		startup_delay -= delta
		if startup_delay <= 0.0:
			# Startup delay is over; let's start the duel
			game_started = true
			synths.play()
			start_duel()
		# Exit here; we do nothing else during the startup wait
		return
	
	# 2) Once the game is started, run the duel logic as before
	var manager = $"/root/GameManager"  # or $"MyNode"
	
	#if (music.playing != true):
	#	music.play()

	if not can_fire:
		timer += delta
		
		# If user presses early, it's a loss
		if manager.get_input_action_1_just_pressed(-1):
			print("You fired too early! You lose!")
			$"cock".play()
			can_fire = false
			prefired = true
			return
		
		# Once wait_time is reached, "FIRE!"
		if timer >= wait_time:
			if prefired == false:
				can_fire = true
			timer = 0.0
			$"Background".color = "#FFFFFF"
			$"Background_Duel".hide()
			print("FIRE!")
			music.stop()
			synths.stop()
			bass1.volume_db = 5
			bass2.volume_db = 5
	else:
		timer += delta
		
		if manager.get_input_action_1_just_pressed(-1):
			if timer <= reaction_window:
				print("Success! You fired in time!")
				$"PlayerCharacter/Gun".texture = gunfire_texture
				$"EnemyCharacter/Bubble".hide()
				$"gunshot".play()
				$"Background".color = "#00FF00"
				lose_character($"EnemyCharacter")
				music.play()
				synths.play()
				bass1.volume_db = 1.5
				bass2.volume_db = -3
			else:
				print("Too late! You lose!")
				$"gunshot2".play()
				$"PlayerCharacter/Bubble".hide()
				$"Background".color = "#FF0000"
				lose_character($"PlayerCharacter")
			reset_duel()
			return
		
		if timer > reaction_window:
			print("Too late! You lose!")
			$"PlayerCharacter/Bubble".hide()
			$"Background".color = "#FF0000"
			lose_character($"PlayerCharacter")
			reset_duel()

func start_duel() -> void:
	# Move your original _ready logic here, so it runs after 1.75s
	randomize()
	# Randomly set the wait time
	wait_time = randf_range(4, 10)
	
	# Adjust reaction window based on difficulty
	reaction_window = reaction_window - (difficulty * 0.5)
	if reaction_window < 0.1:
		reaction_window = 0.1
	
	print("Get ready! Don't fire yet...")
	$"cock".play()
	$"Background".color = "#000000"

func reset_duel() -> void:
	timer = 0.0
	can_fire = false
	prefired = false
	$"Background".color = "#000000"
	$"Background_Duel".show()
	# Randomize wait_time again
	wait_time = randf_range(4, 10)
	print("Get ready! Don't fire yet...")
	$"cock".play()

func lose_character(character_node: Node2D) -> void:
	# This creates a Tween and starts animating the node's `position.y`
	# to a large positive value (e.g. 1500) over 1 second.
	var tween = get_tree().create_tween()
	tween.tween_property(character_node, "position:y", 1500, 1.0) \
		.set_ease(Tween.EASE_IN) \
		.set_trans(Tween.TRANS_QUAD)
