extends Node3D
var obj = load("res://scenes/objects/starlink.tscn")


# расчет сетки
func calculate_group(radius: int, cube_size: int):
	# расчет первого кольца
	var count: int = floor(360. / cube_size)
	_add_ring(radius, count, 360. / count)
	var ring_count = floor((count - 1) / 2.)
	
	# раставление колец по всей высоте планеты
	for i in range(ring_count):
		_add_ring(radius, count, 360. / count, i * (90. / ring_count))
		_add_ring(radius, count, 360. / count, -(i * (90. / ring_count)))
	

# создание кольца
func _add_ring(radius: int, count: int, t_step: float, y: float = 0):
	var t: float = 0.
	for i in range(count):
		add_child(obj.instantiate())
		get_child(-1).calculation_parameters(radius, t, 90 + y)
		t += t_step
