extends Node3D

# изменяемые данные
@export var object_name: String = "кубсат"
@export var color_marker: Color = Color.AQUA
var model_name: String = ""
@export var weight: float = 1.
@export var cross_sectional_area: float = 0.25

# параметры
var h: float = 100.

var inclination: float = deg_to_rad(90.) # наклонение
var ascending_node: float = deg_to_rad(90.) # долгота восходящего узла

var angle: float = deg_to_rad(0.)
const per: float = deg_to_rad(0.)

# данные для записи
var start_angle: float = deg_to_rad(90.)
var circle_count: int = 0	# количество кругов за день
var previous_day: int = 0

var tracker = null


func _ready() -> void:
	model_name = scene_file_path.split("/")[-1].split(".")[0]
	previous_day = Settings.Day_counter
	rotate_x(deg_to_rad(90.))


# применение начальной озиции объекта
func calculation_parameters(new_radius: float, new_weight: float, new_cross_sectional_area: float,
							new_inclination: float, new_ascending_node: float):
	h = (float(new_radius) + Settings.SystemPlanet_radius) * Settings.Unit_distance
	inclination = deg_to_rad(new_inclination)
	ascending_node = deg_to_rad(new_ascending_node)
	if new_weight != 0.: weight = new_weight
	if new_cross_sectional_area != 0.: cross_sectional_area = new_cross_sectional_area
	update_pos()
	#update_rotation()
	

func _process(delta: float) -> void:
	# изменение параметров
	if not Settings.Video_stop_system:
		#update_rotation()
		update_pos()
		update_h(delta)
		angle += deg_to_rad((360. * delta) / get_t())
		# увеличесние счетчика количества оборотов
		if angle > 2. * PI + start_angle:
			circle_count += floor(angle / (2. * PI))
			angle -= (2. * PI) * floor(angle / (2. * PI))
	if get_real_h() < 0 or h < 0:
		if tracker:
			tracker.obj_state = Settings.ObjectsStates.FELL
			tracker.h_measurements.append(0)
		Settings.Video_stop_system = Settings.Video_stop_after_fall
		self.queue_free()
		get_parent().remove_child(self)
		return
	if previous_day != Settings.Day_counter:
		if tracker: tracker.h_measurements.append(get_real_h())
		circle_count = 0
		previous_day = Settings.Day_counter


# Изменение расположения объекта на окружности
func update_pos():
	var t_s = h * sin(angle)
	var t_c = h * cos(angle)
	
	var x: float = h * ((cos(ascending_node) * cos(per - angle)) - (sin(ascending_node) * sin(per - angle) * cos(inclination)))
	var y: float = h * ((sin(ascending_node) * cos(per - angle)) + (cos(ascending_node) * sin(per - angle) * cos(inclination)))
	var z: float = h * sin(per - angle) * sin(inclination)
	
	get_child(0).position = Vector3(x, y, z)


func update_h(delta: float):
	var p: float = Settings.saturation[Settings.saturation.keys()[-1]]
	if round(get_real_h()) in Settings.saturation.keys():
		p = Settings.saturation[round(get_real_h())]
		
	var delta_R = 4. * PI * p * (get_real_speed() ** 2.) * cross_sectional_area * (get_real_h() * 1000.)
	delta_R /= (Settings.SystemPlanet_gravitation * weight)
	delta_R *= Settings.Unit_distance
	h -= ((delta_R * delta / 360.) * Settings.SystemPlanet_turnover_period / Settings.Video_speed)
	


# поворот объекта к планете	
func update_rotation():
	get_child(0).rotation_degrees.y = rad_to_deg(angle) + 90.
	get_child(0).rotation_degrees.z = rad_to_deg(angle) + 90. + 180.


# возврат размера трехмерной модели (для отображения маркера объекта)
func get_model_size(): return get_child(0).get_child(0).get_aabb().size * get_child(0).scale

# получение приведенного радиуса
func get_real_h() -> float:
	return h / Settings.Unit_distance - Settings.SystemPlanet_radius

# получение приведенной скорости
func get_real_speed() -> float:
	var s = sqrt((Settings.SystemPlanet_weight * Settings.G) / ((Settings.SystemPlanet_radius * 1000.) + (get_real_h() * 1000.)))
	return s
	
func get_real_t():
	var t: float = (Settings.SystemPlanet_radius + get_real_h()) / (Settings.SystemPlanet_radius + Settings.Geostationary_orbit)
	return Settings.SystemPlanet_turnover_period * (t ** (3. / 2.))

func get_t() -> float:
	return (get_real_t() * Settings.Video_speed) / Settings.SystemPlanet_turnover_period
