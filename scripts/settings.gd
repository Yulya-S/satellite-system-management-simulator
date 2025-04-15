extends Node

# сигналы
signal changing_Video_scale(value: int)
signal changing_Video_image_idx(idx: int)
signal changing_Video_show_saturation()
signal changing_VideoCamera_x(value: int)
signal changing_VideoCamera_y(value: int)
signal changing_VideoImage_brightness(value: float)
signal changing_VideoImage_fog(value: float)
signal changing_VideoImage_color(value: Color)
signal changing_SystemStar_activity(value: float)

signal add_object(object: String, radius: int, t: int, y: int)
signal add_net(radius: int, step: int)

signal add_tracker(object)
signal remove_tracker(object)


# список состояний
enum TrackerStates {NORMAL, HOVER, ACTIVE}

# константы
const G: float = 6.67 * (10. ** -11)
var saturation = {} # Насыщенность воздуха химическими элементами

# данные системы
var Unit_distance: float = 1. # приведение растояния (пиксели) к реальному значению (км)
var Day_counter: int = 0
var Changing_day_count: bool = false


# изменяемые значения
# настройки видео
var Video_speed: int = 1
var Video_scale: int = 150
var Video_image_idx: int = 0
var Video_show_saturation: bool = true

var VideoCamera_x: int = 270
var VideoCamera_y: int = 0

var VideoImage_brightness: float = 1.
var VideoImage_fog: float = 0.
var VideoImage_color: Color = Color.WHITE


# настройки планетарной системы
var Planet_preset = "earth" # выбранный шаблон планеты
# настройки планеты
var SystemPlanet_radius: float = 6378.
var SystemPlanet_gravitation: float = 1.
var SystemPlanet_weight: float = 1.

# настройки звезду планетарной системы
var SystemStar_activity: float = 1.


# вычисление значения единицы растояния
func calculation_unit_distance(planet_scene):
	var sphare_radius = planet_scene.get_child(0).get_child(0).get_aabb().size[0] * planet_scene.get_child(0).scale[0]
	Settings.Unit_distance = sphare_radius / (Settings.SystemPlanet_radius * 2)


# Применение текста при ошибке ввода
func set_error(message, text: String = ""):
	if text == "": message.set_text("")
	else: message.set_text("Ошибка ввода! " + text)


# создание конфигурационной дериктории
func create_dir():
	# создание основной папки
	var dir = DirAccess.open("res://")
	dir.make_dir("data")
	dir = DirAccess.open("res://data")
	dir.make_dir("objects") # результаты расчетов
	dir.make_dir("planet_presets") # настройки планет
	
	# создание стандартных настроек
	create_config_file()
	create_planet_presets()
	create_air_saturation_file()
	
	# очистка результатов расчетов
	var path = "res://data/objects/"
	dir = DirAccess.open(path)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		OS.move_to_trash(ProjectSettings.globalize_path(path + file_name))
		file_name = dir.get_next()
	
	# чтение настроек
	read_config_file()
	read_planet_file()
	read_saturation_file()

# создание стандартных данных конфигурации
func create_config_file():
	var file = "res://data/config.json"
	if FileAccess.file_exists(file): return
	file = FileAccess.open(file, FileAccess.WRITE)
	var data = {
		"Planet_preset" = "earth",
		"Video_speed" = 1,
		"Video_scale" = 150,
		"Video_image_idx" = 0,
		"Video_show_saturation" = true,
		"VideoCamera_x" = 270,
		"VideoCamera_y" = 0,
		"VideoImage_brightness" = 1.,
		"VideoImage_fog" = 0.,
		"VideoImage_color" = Color.WHITE.to_html()
	}
	file.store_line(JSON.stringify(data))

# создание стандартных пресетов планет
func create_planet_presets():
	var file = "res://data/planet_presets/earth.json"
	if not FileAccess.file_exists(file):
		file = FileAccess.open(file, FileAccess.WRITE)
		var data = {
			"Planet_radius" = 6378.,
			"SystemPlanet_gravitation" = 9.807,
			"SystemPlanet_weight" = 5.972E24
		}
		file.store_line(JSON.stringify(data))

# создание файла с данными по плотности воздуха (от 0 км до 20 км)
func create_air_saturation_file():
	var file = "res://data/air_saturation.txt"
	if FileAccess.file_exists(file): return
	file = FileAccess.open(file, FileAccess.WRITE)
	file.store_line("3.0733778923463335e-134 0.0\n2.1081135682369468e-134 1.0
1.4077175289960447e-134 2.0\n9.256722711838169e-135 3.0\n6.05036200323462e-135 4.0
3.959759194749001e-135 5.0\n2.5998469431297575e-135 6.0\n1.692062600349413e-135 7.0
1.0779062307772853e-135 8.0\n6.6561054522095284e-136 9.0\n3.956389739735531e-136 10.0
2.2588969388092237e-136 11.0\n1.2515806741938476e-136 12.0\n6.807634137968026e-137 13.0
3.6713785255297746e-137 14.0\n1.980106826452151e-137 15.0\n1.0740878086003172e-137 16.0
5.845420215542337e-138 17.0\n3.1791181607573224e-138 18.0\n1.721980704674219e-138 19.0")


# загрузка системных настроек
func read_config_file(chapter: String = ""):
	var variables = []
	for i in get_property_list(): variables.push_back(i.name)

	var data = FileAccess.open("res://data/config.json", FileAccess.READ).get_line()
	var json = JSON.new()
	if not json.parse(data) == OK: return
	data = json.data
	for i in data.keys():
		if i not in variables: continue
		if "color" in i: data[i] = Color(data[i])
		if chapter in i or chapter == "": set(i, data[i])

# загрузка настроек планеты
func read_planet_file():
	var variables = []
	for i in get_property_list(): variables.push_back(i.name)
	
	var data = "res://data/planet_presets/" + Planet_preset + ".json"
	if not FileAccess.file_exists(data):
		Planet_preset = "earth"
		data = "res://data/planet_presets/earth.json"
	data = FileAccess.open(data, FileAccess.READ).get_line()
	var json = JSON.new()
	if not json.parse(data) == OK: return
	data = json.data
	for i in data.keys():
		if i not in variables: continue
		set(i, data[i])

# заполнение массива насыщенности воздуха
func read_saturation_file():
	saturation = {}
	var file = "res://data/air_saturation.txt"
	if not FileAccess.file_exists(file): return
	file = FileAccess.get_file_as_string(file)
	for i in file.split("\n"):
		var data = i.replace("\r", "").split(" ")
		if i != "": Settings.saturation[float(data[1])] = float(data[0])
