extends Node3D

@onready var System = $System
@onready var environment = $WorldEnvironment.environment
@onready var SystemStar = $SpotLight3D
@onready var Tracker = $"../../../CanvasLayer/Tracking/ScrollContainer/Tracking"
@onready var Count = $"../../../CanvasLayer/Count"


func _ready() -> void:
	# добавление сигналов
	Settings.connect("changing_Video_image_idx", Callable(self, "_changing_image_id"))
	Settings.connect("changing_VideoImage_brightness", Callable(self, "_changing_image_brightness"))
	Settings.connect("changing_VideoImage_fog", Callable(self, "_changing_image_fog"))
	Settings.connect("changing_VideoImage_color", Callable(self, "_changing_image_color"))
	Settings.connect("changing_SystemStar_activity", Callable(self, "_changing_star_activity"))
	Settings.connect("add_object", Callable(self, "_add_object"))
	Settings.connect("add_net", Callable(self, "_add_net"))
	
	# применение стандартных значений
	_changing_image_id(Settings.Video_image_idx)
	_changing_image_brightness(Settings.VideoImage_brightness)
	_changing_image_fog(Settings.VideoImage_fog)
	_changing_image_color(Settings.VideoImage_color)
	_changing_star_activity(Settings.SystemStar_activity)


func _process(_delta: float) -> void:
	Count.set_text(str(System.get_child_count())) # пометка количества объектов в системе


# изменение фона окужения
func _changing_image_id(idx: int):
	environment.sky.sky_material.panorama = load("res://img/environments/" + str(idx + 1) + ".jpg")
	Settings.Video_image_idx = idx

# изменение яркости окружения
func _changing_image_brightness(value: float):
	environment.sky.sky_material.energy_multiplier = value
	Settings.VideoImage_brightness = value

# изменение силы тумана
func _changing_image_fog(value: float):
	environment.fog_sky_affect = value
	Settings.VideoImage_fog = value

# изменение цвет тумана
func _changing_image_color(value: Color):
	environment.fog_light_color = value
	Settings.VideoImage_color = value

# изменение активности солнца
func _changing_star_activity(value: float):
	SystemStar.light_energy = value + 1.5
	Settings.SystemStar_activity = value


# добавление трекера для объекта
func _add_tracker():
	Tracker.add_child(load("res://scenes/interface/tracker.tscn").instantiate())
	Tracker.get_child(-1).set_tracker_owner(System.get_child(-1))
	Tracker.move_child(Tracker.get_child(-1), 0)


# добавление нового объекта
func _add_object(object: String, radius: float, inclination: float, ascending_node: float):
	System.add_child(load(object).instantiate())
	System.get_child(-1).calculation_parameters(radius, inclination, ascending_node)
	_add_tracker()

	
# добавление сетки
func _add_net(radius: int, step: int):
	System.add_child(load("res://scenes/objects/satelite_group.tscn").instantiate())
	System.get_child(-1).calculate_group(radius, step)
	_add_tracker()
