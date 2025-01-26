extends Node

var bus_index
var music 
var synths
var bass1
var bass2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	music = $"/root/MusicPlayer"
	synths = $"/root/MusicPlayer/160 to 140"
	bass1 = $"/root/MusicPlayer/160 to 141"
	bass2 = $"/root/MusicPlayer/160 to 142"
	bus_index = AudioServer.get_bus_index("Master")
	# Find the bus index for "Master" or any custom bus name
	
	
	# Create a new LowPass effect
	var low_pass = AudioEffectLowPassFilter.new()
	low_pass.cutoff_hz = 5000.0  # Customize cutoff frequency
	low_pass.resonance = 2.0    # Customize resonance
	
	# Add it as an effect to the bus (in effect slot 0 here)
	AudioServer.add_bus_effect(bus_index, low_pass, 0)
	synths.bus = "Master"

func _exit_tree() -> void:
	AudioServer.remove_bus_effect(bus_index, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
