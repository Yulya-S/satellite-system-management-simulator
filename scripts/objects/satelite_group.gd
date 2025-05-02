extends Node3D

# изменяемые данные
@export var object_name: String = "starlink"
@export var color_marker: Color = Color.DARK_GREEN
@export var unique: bool = false
var model_name: String = ""

# объекты в группе
var obj = load("res://scenes/objects/starlink.tscn")

# количество пройденых кругов первого объекта в группе
var circle_count: int = 0


# получение данных о количестве пройденых кругов первого объекта в группе
func _process(_delta: float) -> void:
	if not model_name: get_child(0).scene_file_path.split("/")[-1].split(".")[0]
	if get_child_count() > 0:
		circle_count = get_child(0).circle_count


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


func get_model_size():
	if get_child_count() > 0: return Vector3(get_child(0).h + 5,  get_child(0).h + 5,  get_child(0).h + 5)
	return Vector3(1., 1., 1.)


func get_real_h():
	if get_child_count() > 0: return get_child(0).get_real_h()
	return 0.


func get_real_speed():
	if get_child_count() > 0: return get_child(0).get_real_speed()
	return 0.
