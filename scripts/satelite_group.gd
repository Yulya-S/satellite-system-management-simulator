extends Node3D
var obj = load("res://scenes/objects/starlink.tscn") # добавить возможность выбора модели

var cube_size: int = 10 # размер квадрата между спутниками
var radius: int = 20 # растояние от центральной точки (не влияет на плотность сетки!)


# расчет сетки
func calculate_group(new_cube_size: int, new_radius: int):
	cube_size = new_cube_size
	radius = new_radius
	
	var count: int = floor(360. / new_cube_size)
	__add_ring(count, 360 / count)
	var ring_count = floor((count - 1) / 2)
	
	for i in range(ring_count):
		__add_ring(count, 360 / count, i * (90 / ring_count))
		__add_ring(count, 360 / count, -(i * (90 / ring_count)))
	

# добавление одного кольца
func __add_ring(count_in_ring: int, t_step: float, sphere_pos_y: float = 0):
	var t: int = 0
	for i in range(count_in_ring):
		add_child(obj.instantiate())
		get_child(-1).calculation_parameters(radius, t, 90 + sphere_pos_y)
		t += t_step
