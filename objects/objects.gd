extends Node3D

var radius = 100 # растояние от центра
var t = 0.0 # текущий поворот
var speed_multiplier = 1 # множитель скорости движения
var speed = 0.0 # скорость движения объекта

func _ready() -> void:
	calculation_parameters()

# расчеты параметров
func calculation_parameters(new_radius: int = -1, new_t: int = -1):
	if new_radius < 0: radius = randi_range(50, 200)
	else: radius = new_radius
	if new_t < 0: t = randf_range(0.0, 2.3)
	else: t = new_t
	speed = randf_range(0.001, 0.01)		


func _process(delta: float) -> void:
	# расчеты по формулам
	var x = radius * cos(t) + radius
	var y = radius * sin(t) + radius
	var x1 = radius * cos(t + 0.1) + radius
	var y1 = radius * sin(t + 0.1) + radius
	
	# изменение поворота объекта
	t += speed_multiplier * speed
	if t > 2 * PI:
		t = 0
	
	# применение новой позиции относительно старой
	position.x = x1 - x
	position.z = y1 - y
