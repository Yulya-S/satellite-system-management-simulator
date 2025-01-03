extends Node3D

var radius = 100
var t = 0.0
var speed_multiplier = 1
var speed = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	radius = randi_range(50, 200)
	t = randf_range(0.0, 2.3)
	speed = randf_range(0.001, 0.01)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var x = radius * cos(t) + radius
	var y = radius * sin(t) + radius
	var x1 = radius * cos(t + 0.1) + radius
	var y1 = radius * sin(t + 0.1) + radius
	
	t += speed_multiplier * speed
	if t > 2 * PI:
		t = 0
	
	position.x = x1 - x
	position.z = y1 - y
