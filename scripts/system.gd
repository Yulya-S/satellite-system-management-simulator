extends Node3D
@onready var System = $System

func _ready() -> void:
	$SpotLight3D.light_energy = Settings.SolarActivity + 1.5

# добавление нового объекта
func add_new_object_in_system(radius: int = -1, t: int = -1, sphare_pos_y: int = -1):
	var cubsat = load("res://scenes/objects/cubsat.tscn")
	System.add_child(cubsat.instantiate())
	System.get_child(-1).calculation_parameters(radius, t, sphare_pos_y)
