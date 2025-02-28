extends Node3D

var radius: int = 100 # растояние от центра
var t: float = deg_to_rad(90) # текущий поворот
var speed: float = 0.0 # скорость движения объекта
var sphere_pos_y: float = deg_to_rad(90) # высота расположения объекта вокруг сферы

func _ready() -> void:
	calculation_parameters()


# расчеты параметров
func calculation_parameters(new_radius: int = -1, new_t: float = -1, new_sphere_pos_y: float = -1):
	if new_radius < 0: radius = randi_range(50, 200)
	else: radius = new_radius
	if new_t < 0: t = deg_to_rad(randi_range(0, 360))
	else: t = deg_to_rad(new_t)
	if new_sphere_pos_y < 0: sphere_pos_y = deg_to_rad(90)
	else: sphere_pos_y = deg_to_rad(new_sphere_pos_y)
	#speed = randf_range(0.001, 0.01)


func _process(delta: float) -> void:
	# расчеты по формулам
	var x = radius * sin(sphere_pos_y) * cos(t)
	var y = radius * cos(sphere_pos_y)
	var z = radius * sin(sphere_pos_y) * sin(t)
	position = Vector3(x, y, z)
	
	# скорость движения объекта
	var e = 1
	speed = sqrt(2 * ((Settings.EarthGravity * Settings.EarthWeight / radius) * 10 + e)) / 100
	
	# следующий шаг
	t += Settings.VideoSimulation_speed / 2. * speed
	if t > 2 * PI:
		t -= 2 * PI
