extends Node3D
var obj = load("res://scenes/objects/starlink.tscn")

var cube_size: int = 10
var radius: int = 20


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var t = 0
	
	add_child(obj.instantiate())
	get_child(-1).calculation_parameters(radius, t)
	add_child(obj.instantiate())
	get_child(-1).calculation_parameters(radius, t, 90 + 45)
	add_child(obj.instantiate())
	get_child(-1).calculation_parameters(radius, t, 45)
	
	t += deg_to_rad(90)
	add_child(obj.instantiate())
	get_child(-1).calculation_parameters(radius, t)
	add_child(obj.instantiate())
	get_child(-1).calculation_parameters(radius, t, 90 + 45)
	add_child(obj.instantiate())
	get_child(-1).calculation_parameters(radius, t, 45)
	
	t += deg_to_rad(90)
	add_child(obj.instantiate())
	get_child(-1).calculation_parameters(radius, t)
	add_child(obj.instantiate())
	get_child(-1).calculation_parameters(radius, t, 90 + 45)
	add_child(obj.instantiate())
	get_child(-1).calculation_parameters(radius, t, 45)
	
	t += deg_to_rad(90)
	add_child(obj.instantiate())
	get_child(-1).calculation_parameters(radius, t)
	add_child(obj.instantiate())
	get_child(-1).calculation_parameters(radius, t, 90 + 45)
	add_child(obj.instantiate())
	get_child(-1).calculation_parameters(radius, t, 45)
	
	
	
	#get_child(-1).position.y = 100
	
func calculate_group(new_cube_size: int, new_radius):
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
