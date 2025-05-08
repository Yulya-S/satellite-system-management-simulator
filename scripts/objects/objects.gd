extends Node3D

# изменяемые данные
@export var object_name: String = "кубсат"
@export var color_marker: Color = Color.AQUA
@export var unique: bool = false
var model_name: String = ""
@export var weight: float = 1.

# параметры
var h: float = 100. # растояние от центра
var angle: float = deg_to_rad(90.) # текущий поворот

var sphere_pos_y: float = deg_to_rad(90.) # высота расположения объекта вокруг сферы
var speed: float = 0. # скорость движения объекта

# данные для записи
var start_angle: float = deg_to_rad(90)
var circle_count: int = 0	# количество кругов за день
var average_speed: float = 0. # средняя скорость за день
var previous_day: int = 0


func _ready() -> void:
	model_name = scene_file_path.split("/")[-1].split(".")[0]
	previous_day = Settings.Day_counter


# применение начальной озиции объекта
func calculation_parameters(new_radius: int, new_angle: float, y: float):
	h = (float(new_radius) + Settings.SystemPlanet_radius) * Settings.Unit_distance
	angle = deg_to_rad(new_angle)
	start_angle = deg_to_rad(new_angle)
	sphere_pos_y = deg_to_rad(y)
	update_pos()
	update_rotation()
	

func _process(delta: float) -> void:
	# изменение параметров
	if not Settings.Video_stop_system:
		update_rotation()
		update_pos()
		angle += deg_to_rad((360. * delta) / get_t())
		# увеличесние счетчика количества оборотов
		if angle > 2. * PI + start_angle:
			circle_count += floor(angle / (2. * PI))
			average_speed += get_real_speed()
			angle -= (2. * PI) * floor(angle / (2. * PI))
	if previous_day != Settings.Day_counter:
		circle_count = 0
		previous_day = Settings.Day_counter


# Изменение расположения объекта на окружности
func update_pos():
	var x = h * sin(sphere_pos_y) * cos(angle)
	var y = h * cos(sphere_pos_y)
	var z = h * sin(sphere_pos_y) * sin(angle)
	position = Vector3(x, y, z)


# поворот объекта к планете	
func update_rotation():
	get_child(0).rotation_degrees.y = -rad_to_deg(angle) + 90
	get_child(0).rotation_degrees.x = rad_to_deg(sphere_pos_y) + 90 + 180

# возврат размера трехмерной модели (для отображения маркера объекта)
func get_model_size(): return get_child(0).get_child(0).get_aabb().size * get_child(0).scale

# получение приведенного радиуса
func get_real_h() -> float:
	return h / Settings.Unit_distance - Settings.SystemPlanet_radius

# получение приведенной скорости
func get_real_speed() -> float:
	return ((2. * PI * (Settings.SystemPlanet_radius + get_real_h())) / get_real_t())
	
func get_real_t():
	var t: float = (Settings.SystemPlanet_radius + get_real_h()) / (Settings.SystemPlanet_radius + Settings.Geostationary_orbit)
	return Settings.SystemPlanet_turnover_period * (t ** (3. / 2.))

func get_t() -> float:
	return (get_real_t() * Settings.Video_speed) / Settings.SystemPlanet_turnover_period
