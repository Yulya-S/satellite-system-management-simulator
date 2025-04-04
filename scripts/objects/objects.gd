extends Node3D

@export var drag_coefficient: float = 1.05
@export var cross_sectional_area: float = 100. / 100.
@export var weight: float = 1.

var radius: float = 100. # растояние от центра
var t: float = deg_to_rad(90) # текущий поворот
var sphere_pos_y: float = deg_to_rad(90) # высота расположения объекта вокруг сферы
var speed: float = 0. # скорость движения объекта

const distance_multiplier: int = 1000


# расчеты параметров
func calculation_parameters(new_radius: int, new_t: float, y: float):
	radius = float(new_radius)
	t = deg_to_rad(new_t)
	sphere_pos_y = deg_to_rad(y)
	speed = sqrt(2 * ((Settings.SystemPlanet_gravitation * Settings.SystemPlanet_weight) / (radius / 1000)) + Settings.e) / 170


func _process(_delta: float) -> void:
	if Settings.Video_speed > 0:
		# расчеты по формулам
		var x = radius * sin(sphere_pos_y) * cos(t)
		var y = radius * cos(sphere_pos_y)
		var z = radius * sin(sphere_pos_y) * sin(t)
		position = Vector3(x, y, z)
		
		# изменение параметров
		update_speed()
		update_radius()
		
		# следующий шаг
		t += speed * (1.3 ** (Settings.Video_speed - 1))
		while t > 2 * PI: t -= 2 * PI


# скорость движения объекта
func update_speed():
	speed = sqrt(2 * ((Settings.SystemPlanet_gravitation * Settings.SystemPlanet_weight) / (radius / distance_multiplier)) + Settings.e) / 170

# изменение радиуса
func update_radius():
	var r = (Settings.SystemPlanet_gravitation * Settings.SystemPlanet_weight) / (85 * (speed ** 2) - Settings.e)
	radius += r * (1.3 ** (Settings.Video_speed - 1)) / distance_multiplier
	

## скорость движения объекта с учетом атмосферы Земли
#func update_speed_with_atmospheric_braking():
	#var acceleration: float = Settings.SystemPlanet_acceleration - (1. / 2. * weight) * \
		#Settings.EarthAirDensity(radius) * drag_coefficient * cross_sectional_area * (speed ** 2)
	#speed -= acceleration / 1000000000 * Settings.Video_speed
	#if speed <= 0: speed = 0.000000001
