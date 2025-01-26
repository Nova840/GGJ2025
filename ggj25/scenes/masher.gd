extends Node2D

# --- CONFIGURABLE VARIABLES ---
var startup_delay: float = 1.75  # Wait 1.75 seconds before game starts
var time_limit: float = 10.0      # How many seconds to mash
var manager                       # Reference to your input manager node

# --- INTERNAL STATE ---
var game_started: bool = false
var mash_timer: float = 0.0
var mash_count: int = 0

# --- DIFFICULTY
var difficulty : int = 0
var base_requirement : int = 65
var difficulty_increment : int = 10
var goal : float = (base_requirement + (difficulty * difficulty_increment))

var frame1 = preload("res://assets/New_Mash_Lizard_Frame_1.png")
var frame2 = preload("res://assets/New_Mash_Lizard_Frame_2.png")
var losers = []

func _ready() -> void:
	# Grab your manager node. Adjust the path to match your actual hierarchy.
	manager = $"/root/GameManager"
	difficulty = manager.rounds_completed/5
	# Print or display a "Get ready!" message. You could also:
	# - play a "countdown" sound
	# - show a UI label
	print("Get ready! Button masher will start in 1.75 seconds...")


func _process(delta: float) -> void:
	# 1) Handle the startup delay
	if not game_started:
		startup_delay -= delta
		if startup_delay <= 0.0:
			# Startup is done; begin the button mash game
			game_started = true
			mash_timer = time_limit
			mash_count = 0
			print("GO! Mash the Space bar for %s seconds!" % str(time_limit))
		return

	# 2) Once the game has started, decrement the mash timer
	mash_timer -= delta
	#$"Background B".hide()
	if mash_timer <= 0.0:
		# Time is up!
		print("TIME'S UP!")
		print("You mashed Space %d times!" % mash_count)
		if (mash_count > goal):
			manager.next_round([] as Array[int])
			print("Victory!")
		else:
			print("Failure")
			manager.next_round([-1] as Array[int]) ## implement failure mechanism here
			
		# Optionally reset for another round, or you can stop here
		# For a one-shot:
		game_started = false
		# If you want the game to just stop, you can "return" or remove the process:
		# set_process(false)
		return

	# 3) If the game is in progress, check for button presses
	#    (Using manager's version of "just pressed")
	if manager.get_input_action_1_just_pressed(-1):
		mash_count += 1
		var increment = 200/goal
		$Player.set_position(Vector2($Player.get_position().x + (increment * 5), $Player.get_position().y - (3 * increment)))
		if (mash_count%2 == 0):
			$Player.texture = frame1
		else:
			$Player.texture = frame2
		$Player/Boulder.rotate(0.1)
		if mash_count > goal:
			$"Background B".show()
		#$"Progress".set_position(Vector2($"Progress".get_position().x, max(-540, 540 - ((540*2) * (mash_count/goal)))))
		#$"Background".color = Color(1, 1, 1) # White flash
		print("Mash count: %d" % mash_count)
		print("Y position: %d" % $"Progress".get_position().y)
		#$"Background B".show()
