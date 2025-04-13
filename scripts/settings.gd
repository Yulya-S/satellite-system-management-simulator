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


# константы
const e: float = 1.
var saturation = {} # Насыщенность воздуха химическими элементами
var Environment_array = ["environment_1.jpg", "environment_2.jpg", "environment_3.jpg"]
var Planet_preset = "earth"

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
var SystemPlanet_radius: float = 6378.
var SystemPlanet_gravitation: float = 1. #6.674 * (10 ** -11)
var SystemPlanet_weight: float = 1. # 5.972 * (10 ** 24)
# var EarthAirDensity: float = 1.225 # плотность воздуха

var SystemStar_activity: float = 1.


# получить плотность воздуха в зависимости от растояния до объекта
func EarthAirDensity(height: float) -> float:
	const AtmosphereAltitude: float = 1.
	return SystemStar_activity * e ** (-height / AtmosphereAltitude)


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
	
	# очистка результатов расчетов
	var path = "res://data/objects/"
	dir = DirAccess.open(path)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		OS.move_to_trash(ProjectSettings.globalize_path(path + file_name))
		file_name = dir.get_next()
	
	# чтение настроек
	read_config_file("Image")
	read_planet_file()
	read_saturation_file()

# создание стандартных данных конфигурации
func create_config_file():
	var file = "res://data/config.json"
	if FileAccess.file_exists(file): return
	file = FileAccess.open(file, FileAccess.WRITE)
	var data = {
		"Environment_array" = ["environment_1.jpg", "environment_2.jpg", "environment_3.jpg"],
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
		if chapter in i: set(i, data[i])


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
