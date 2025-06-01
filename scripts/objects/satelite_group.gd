extends Node3D

# изменяемые данные
@export var object_name: String = "starlink"
@export var color_marker: Color = Color.DARK_GREEN
var model_name: String = ""

# объекты в группе
var obj = load("res://scenes/objects/starlink.tscn")
var tracker = null

# количество пройденых кругов первого объекта в группе
var circle_count: int = 0
var previous_day: int = 0


func _ready() -> void: previous_day = Settings.Day_counter

# получение данных о количестве пройденых кругов первого объекта в группе
func _process(_delta: float) -> void:
	if not model_name and get_child(0).get_child_count() > 0:
		model_name = get_child(0).get_child(0).get_child(0).scene_file_path.split("/")[-1].split(".")[0]
		tracker.owner_main_data[1] = model_name
	if get_child(0).get_child_count() > 0:
		if previous_day != Settings.Day_counter:
			if tracker: tracker.h_measurements.append(get_real_h())
			previous_day = Settings.Day_counter
			circle_count = get_child(0).get_child(0).circle_count
	if get_child(0).get_child_count() < 0:
		if tracker:
			tracker.obj_state = Settings.ObjectsStates.DESTROYED
			tracker.h_measurements.append(0)
		Settings.Video_stop_system = Settings.Video_stop_after_fall
		self.queue_free()
		get_parent().remove_child(self)


# расчет сетки
func calculate_group(radius: int, cube_size: int):
	# расчет первого кольца
	var count: int = floor(360. / cube_size)
	_add_ring(radius, count, 360. / count)
	var ring_count = floor((count - 1) / 2.)
	_add_ring(radius, count, 360. / count, ring_count * (90. / ring_count))
	
	# раставление колец по всей высоте планеты
	for i in range(1, ring_count, 1):
		_add_ring(radius, count, 360. / count, i * (90. / ring_count))
		_add_ring(radius, count, 360. / count, -(i * (90. / ring_count)))
	

# создание кольца
func _add_ring(radius: int, count: int, t_step: float, y: float = 0.):
	var t: float = 0.
	for i in range(count):
		get_child(0).add_child(obj.instantiate())
		get_child(0).get_child(-1).calculation_parameters(radius, 0., 0., y, 0.)
		get_child(0).get_child(-1).angle = deg_to_rad(t)
		get_child(0).get_child(-1).start_angle = deg_to_rad(t)
		get_child(0).get_child(-1).update_pos()
		t += t_step


func get_model_size() -> Vector3:
	if get_child(0).get_child_count() > 0: return Vector3(get_child(0).get_child(0).h + 5, 
											 			  get_child(0).get_child(0).h + 5, 
														  get_child(0).get_child(0).h + 5)
	return Vector3(1., 1., 1.)


func get_real_h() -> float:
	if get_child(0).get_child_count() > 0: return get_child(0).get_child(0).get_real_h()
	return 0.


func get_real_speed() -> float:
	if get_child(0).get_child_count() > 0: return get_child(0).get_child(0).get_real_speed()
	return 0.
