extends Node3D

@export var object_name: String = "кубсат"
@export var model_name: String = "cubsat"
@export var color_marker: Color = Color.AQUA

@export var drag_coefficient: float = 1.05
@export var cross_sectional_area: float = 100. / 100.
@export var weight: float = 1.

var radius: float = 100. # растояние от центра
var t: float = deg_to_rad(90) # текущий поворот
var sphere_pos_y: float = deg_to_rad(90) # высота расположения объекта вокруг сферы
var speed: float = 0. # скорость движения объекта

var start_t: float = deg_to_rad(90)
var circle_count: int = 0
var average_speed: float = 0.

# расчеты параметров
func calculation_parameters(new_radius: int, new_t: float, y: float):
	radius = (float(new_radius) + Settings.SystemPlanet_radius) * Settings.Unit_distance
	t = deg_to_rad(new_t)
	start_t = deg_to_rad(new_t)
	sphere_pos_y = deg_to_rad(y)
	speed = (sqrt((Settings.G*Settings.SystemPlanet_weight) / (get_real_r() ** 2)) * Settings.Unit_distance) / 50
	update_rotation()


func _process(_delta: float) -> void:
	# расчеты по формулам
	var x = radius * sin(sphere_pos_y) * cos(t)
	var y = radius * cos(sphere_pos_y)
	var z = radius * sin(sphere_pos_y) * sin(t)
	position = Vector3(x, y, z)
	update_rotation()
	if Settings.Video_speed > 0:
		# изменение параметров
		speed += get_delta_speed() * Settings.Unit_distance
		radius += get_delta_radius() * Settings.Unit_distance
		
		# следующий шаг
		t += speed * (1.3 ** (Settings.Video_speed - 1))
		if t - start_t > 2. * PI:
			circle_count += floor(t / (2. * PI))
			average_speed += speed * floor(t / (2. * PI))
			t -= (2 * PI) * floor(t - start_t / (2. * PI))
				

# поворот объекта к планете	
func update_rotation():
	get_child(0).rotation_degrees.y = -rad_to_deg(t) + 90
	get_child(0).rotation_degrees.x = rad_to_deg(sphere_pos_y) + 90

# получение приведенного радиуса
func get_real_r() -> float:
	return radius / Settings.Unit_distance - Settings.SystemPlanet_radius

# получение приведенной скорости
func get_real_speed() -> float:
	return speed / Settings.Unit_distance

# получение силы трения
func get_F() -> float:
	var p = 0.
	if round(get_real_r()) in Settings.saturation.keys():
		p = Settings.saturation[round(get_real_r())]
	return 2.5 * (p * (get_real_speed() ** 2) / 2.) / 1E14

# значение изменения скорости движения объекта
func get_delta_speed() -> float:
	return (2. * PI * get_F() * get_real_r()) / (weight * get_real_speed())

# значение изменения радиуса
func get_delta_radius() -> float:
	return - (2. * get_real_r() * get_delta_speed()) / get_real_speed()


# сохранение данных за день в файл
func save_data():
	var file = "res://data/objects/" + scene_file_path.split("/")[-1].split(".")[0] + str(get_instance_id())+ ".txt"
	if FileAccess.file_exists(file):
		file = FileAccess.open(file, FileAccess.READ_WRITE)
	else:
		file = FileAccess.open(file, FileAccess.WRITE)
	file.seek_end()
	file.store_line(str(Settings.Day_counter) + " " + str(circle_count) + " " \
					+ str(average_speed  / circle_count) + " " +  str(get_real_r()))
	file.close()
	circle_count = 0
	average_speed = 0.
