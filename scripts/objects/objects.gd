extends Node3D

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
	speed = 0.1
	update_rotation()


func _process(_delta: float) -> void:
	# расчеты по формулам
	var x = radius * sin(sphere_pos_y) * cos(t)
	var y = radius * cos(sphere_pos_y)
	var z = radius * sin(sphere_pos_y) * sin(t)
	position = Vector3(x, y, z)
	
	if Settings.Video_speed > 0:
		# изменение параметров
		update_rotation()
		#if ceil(radius) < 450: update_speed_with_atmospheric_braking()
		update_speed()
		#update_radius()
		
		# следующий шаг
		t += speed * (1.3 ** (Settings.Video_speed - 1))
		while t - start_t > 2 * PI:
			t -= 2 * PI
			circle_count += 1
			average_speed += speed
			
			

# поворот объекта к планете	
func update_rotation():
	get_child(0).rotation_degrees.y = -rad_to_deg(t) + 90
	get_child(0).rotation_degrees.x = rad_to_deg(sphere_pos_y) + 90
	

# скорость движения объекта
func update_speed():
	var s = sqrt(2 * ((Settings.SystemPlanet_gravitation * Settings.SystemPlanet_weight) / get_real_r() + Settings.e))
	speed = s * Settings.Unit_distance / (10 ** 10 - 10 ** 9 * 4)

# изменение радиуса
func update_radius(): pass
	#var r = (Settings.SystemPlanet_gravitation * Settings.SystemPlanet_weight) / (85 * (speed ** 2) - Settings.e)
	#radius += r * (1.3 ** (Settings.Video_speed - 1)) / distance_multiplier
	
	
func get_real_r():
	return radius / Settings.Unit_distance - Settings.SystemPlanet_radius
	

# скорость движения объекта с учетом атмосферы Земли
func update_speed_with_atmospheric_braking():
	#var acceleration: float = Settings.SystemPlanet_acceleration - (1. / 2. * weight) * \
		#Settings.saturation[ceil(radius)] / distance_multiplier * drag_coefficient * cross_sectional_area * (speed ** 2)
	#speed -= acceleration / 1000000000 * Settings.Video_speed
	if speed <= 0: speed = 0.000000001


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
