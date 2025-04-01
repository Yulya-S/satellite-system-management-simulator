extends Node3D

@export var drag_coefficient: float = 1.05
@export var cross_sectional_area: float = 100. / 100.
@export var weight: float = 1.

var radius: float = 100. # растояние от центра
var t: float = deg_to_rad(90) # текущий поворот
var sphere_pos_y: float = deg_to_rad(90) # высота расположения объекта вокруг сферы

var speed: float = 0. # скорость движения объекта


func _ready() -> void:
	calculation_parameters()


# расчеты параметров
func calculation_parameters(new_radius: int = -1, new_t: float = -1, new_sphere_pos_y: float = -1):
	if new_radius < 0: radius = float(randi_range(50, 200))
	else: radius = float(new_radius)
	if new_t < 0: t = deg_to_rad(randi_range(0, 360))
	else: t = deg_to_rad(new_t)
	if new_sphere_pos_y < 0: sphere_pos_y = deg_to_rad(90)
	else: sphere_pos_y = deg_to_rad(new_sphere_pos_y)
	speed = sqrt(2 * ((Settings.EarthGravity * Settings.EarthWeight / radius) * 10 + Settings.e)) / 100


func _process(delta: float) -> void:
	# расчеты по формулам
	var x = radius * sin(sphere_pos_y) * cos(t)
	var y = radius * cos(sphere_pos_y)
	var z = radius * sin(sphere_pos_y) * sin(t)
	position = Vector3(x, y, z)
	
	# изменение параметров
	if radius > 20: update_speed()
	else: update_speed_with_atmospheric_braking()
	update_radius()
		
	# следующий шаг
	t += Settings.VideoSimulation_speed / 2. * speed
	while t > 2 * PI:
		t -= 2 * PI


# скорость движения объекта
func update_speed():
	speed = sqrt(2 * ((Settings.EarthGravity * Settings.EarthWeight / radius) * 10 + Settings.e)) / 100

# скорость движения объекта с учетом атмосферы Земли
func update_speed_with_atmospheric_braking():
	var acceleration: float = Settings.EarthAccelerationOfGravity - (1. / 2. * weight) * \
		Settings.EarthAirDensity(radius) * drag_coefficient * cross_sectional_area * (speed ** 2)
	speed -= acceleration / 1000000000 * Settings.VideoSimulation_speed
	if speed <= 0: speed = 0.000000001

# изменение радиуса
func update_radius():
	var r = (Settings.EarthGravity * Settings.EarthWeight * 10) / (((speed ** 2) / 2) - Settings.e) / 10000
	radius += r * Settings.VideoSimulation_speed
