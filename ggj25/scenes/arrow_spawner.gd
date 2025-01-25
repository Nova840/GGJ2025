extends Node2D

var rounds = 0
var bpm = 160 * pow(1.1, (0/5))
var arrow_tick_rate = bpm 
var arrow_speed_base = 0
var arrow_speed_increment = 0
var arrow_speed = arrow_speed_base + (arrow_speed_increment * rounds/5)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
