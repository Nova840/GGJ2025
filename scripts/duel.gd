extends Node


var gunfire_texture = preload("res://assets/Duel_Gun_Fire_Animation .png")

var startup_delay: float = 1.75  # Wait 1.75 seconds before the game actually starts
var game_started: bool = false   # We'll flip this once the delay is over
var wait_time: float = 0.0       # How long until "FIRE!"
var reset_time: float = 4.0
var timer: float = 0.0           # Track elapsed time
var can_fire: bool = false       # Whether the player is allowed to fire
var difficulty: int = 0          # The higher this is, the shorter the reaction window
var reaction_window: float = 1.5   # Time window to succeed after "FIRE!"
var prefired: Array[int] = []
var fired_hit: Array[int] = []
var tween: Tween


func _process(delta: float) -> void:
	if not game_started:
		startup_delay -= delta
		if startup_delay <= 0.0:
			# Startup delay is over; let's start the duel
			game_started = true
			start_duel()
		# Exit here; we do nothing else during the startup wait
		return

	# Once the game is started, run the duel logic as before
	var manager = $"/root/GameManager"  # or $"MyNode"
	difficulty = manager.rounds_completed

	if not can_fire:
		timer += delta

		# If user presses early, it's a loss
		for p in GameManager.alive_players:
			if manager.get_input_action_1_just_pressed(p):
				$"cock".play()
				can_fire = false
				if not prefired.has(p):
					prefired.append(p)

		# Once wait_time is reached, "FIRE!"
		if timer >= wait_time:
			can_fire = true
			timer = 0.0
			$"Background".color = "#FFFFFF"
			$"Background_Duel".hide()
	else:
		timer += delta

		for p in GameManager.alive_players:
			if manager.get_input_action_1_just_pressed(p):
				if timer <= reaction_window:
					$"PlayerCharacter/Gun".texture = gunfire_texture
					$"EnemyCharacter/Bubble".hide()
					$"gunshot".play()
					$"Background".color = "#00FF00"
					lose_character($"EnemyCharacter")
					fired_hit.append(p)
				else:
					$"gunshot2".play()
					$"PlayerCharacter/Bubble".hide()
					$"Background".color = "#FF0000"
					lose_character($"PlayerCharacter")

		if timer > reaction_window:
			$"PlayerCharacter/Bubble".hide()
			$"Background".color = "#FF0000"
			lose_character($"PlayerCharacter")
			var players_lost: Array[int] = GameManager.alive_players.duplicate()
			for i in range(players_lost.size() - 1, -1, -1):  # Iterate backwards
				if fired_hit.has(players_lost[i]) and not prefired.has(players_lost[i]):
					players_lost.remove_at(i)
			manager.next_round(players_lost)


func start_duel() -> void:
	# Move your original _ready logic here, so it runs after 1.75s
	randomize()
	# Randomly set the wait time
	wait_time = randf_range(4, 10)

	# Adjust reaction window based on difficulty
	reaction_window = reaction_window - (difficulty * 0.4)
	if reaction_window < 0.1:
		reaction_window = 0.1

	$"cock".play()
	$"Background".color = "#000000"


func lose_character(character_node: Node2D) -> void:
	# This creates a Tween and starts animating the node's `position.y`
	# to a large positive value (e.g. 1500) over 1 second.
	tween = get_tree().create_tween()
	tween.tween_property(character_node, "position:y", 1500, 1.0) \
		.set_ease(Tween.EASE_IN) \
		.set_trans(Tween.TRANS_QUAD)


func _exit_tree() -> void:
	if is_instance_valid(tween): tween.kill()
