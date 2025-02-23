extends Node2D

# --- CONFIGURABLE VARIABLES ---
var startup_delay: float = 1.75  # Wait 1.75 seconds before game starts
var time_limit: float = 10.0      # How many seconds to mash

# --- INTERNAL STATE ---
var game_started: bool = false
var mash_timer: float = 0.0
var mash_count: Array[int]

# --- DIFFICULTY
var difficulty : int = 0
var base_requirement : int = 65
var difficulty_increment : int = 10
var goal : float = (base_requirement + (difficulty * difficulty_increment))

var frame1 = preload("res://assets/New_Mash_Lizard_Frame_1.png")
var frame2 = preload("res://assets/New_Mash_Lizard_Frame_2.png")

func _ready() -> void:
	# Grab your manager node. Adjust the path to match your actual hierarchy.
	difficulty = GameManager.rounds_completed / 5
	for p in GameManager.alive_players:
		mash_count.append(0)

func _process(delta: float) -> void:
	# 1) Handle the startup delay
	if not game_started:
		startup_delay -= delta
		if startup_delay <= 0.0:
			# Startup is done; begin the button mash game
			game_started = true
			mash_timer = time_limit
		return

	# 2) Once the game has started, decrement the mash timer
	mash_timer -= delta
	#$"Background B".hide()
	if mash_timer <= 0.0:
		var players_lost: Array[int] = []
		for i in GameManager.alive_players.size():
			if (mash_count[i] < goal):
				players_lost.append(GameManager.alive_players[i])
		GameManager.next_round(players_lost)

		# Optionally reset for another round, or you can stop here
		# For a one-shot:
		game_started = false
		# If you want the game to just stop, you can "return" or remove the process:
		# set_process(false)
		return

	# 3) If the game is in progress, check for button presses
	#    (Using GameManager's version of "just pressed")
	for i in GameManager.alive_players.size():
		if GameManager.get_input_action_1_just_pressed(GameManager.alive_players[i]):
			mash_count[i] += 1
			var increment = 200 / goal
			$Player.set_position(Vector2($Player.get_position().x + (increment * 5), $Player.get_position().y - (3 * increment)))
			var all_players_mash_count := 0
			for j in mash_count:
				all_players_mash_count += mash_count[i]
			if (all_players_mash_count % 2 == 0):
				$Player.texture = frame1
			else:
				$Player.texture = frame2
			$Player/Boulder.rotate(0.1)
			if all_players_mash_count >= goal:
				$"Background B".show()
