extends Node3D

@onready var System = $System
@onready var environment = $WorldEnvironment.environment


func _ready() -> void:
	Settings.connect("сhanging_Video_image_idx", Callable(self, "_сhanging_environment"))
	Settings.connect("сhanging_VideoImage_brightness", Callable(self, "_сhanging_environment_brightness"))
	Settings.connect("сhanging_VideoImage_fog", Callable(self, "_сhanging_environment_fog"))
	$SpotLight3D.light_energy = Settings.SolarActivity + 1.5
	
	_сhanging_environment(Settings.Video_image_idx)
	_сhanging_environment_brightness(Settings.VideoImage_brightness)
	_сhanging_environment_fog(Settings.VideoImage_fog)


# добавление нового объекта
func add_new_object_in_system(radius: int = -1, t: int = -1, sphare_pos_y: int = -1):
	var cubsat = load("res://scenes/objects/cubsat.tscn")
	System.add_child(cubsat.instantiate())
	System.get_child(-1).calculation_parameters(radius, t, sphare_pos_y)

func _сhanging_environment(idx: int):
	environment.sky.sky_material.panorama = load("res://img/"+Settings.Environment_array[idx])
	Settings.Video_image_idx = idx

func _сhanging_environment_brightness(value: float):
	environment.sky.sky_material.energy_multiplier = value
	Settings.VideoImage_brightness = value

func _сhanging_environment_fog(value: float):
	environment.fog_sky_affect = value
	Settings.VideoImage_fog = value
