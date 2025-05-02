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
const G: float = 6.67430E-11 # гравитационная постоянная
var saturation = {} # Насыщенность воздуха химическими элементами

# данные системы
var Unit_distance: float = 1. # приведение растояния (пиксели) к реальному значению (км)
var Geostationary_orbit: float = 0. # высота геостационарной орбиты
var Day_counter: int = 0
var Changing_day_count: bool = false


# изменяемые значения
# настройки видео
var Video_speed: int = 1
var Video_speed_idx: int = 2
var Video_scale: int = 150
var Video_image_idx: int = 0
var Video_show_saturation: bool = true
var Video_stop_system: bool = false

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
var SystemPlanet_turnover_period: float = 86400.

# настройки звезду планетарной системы
var SystemStar_activity: float = 1.


# вычисление значения единицы растояния
func calculation_unit_distance(planet_scene):
	var sphare_radius = planet_scene.get_child(0).get_child(0).get_aabb().size[0] * planet_scene.get_child(0).scale[0]
	Settings.Unit_distance = sphare_radius / (Settings.SystemPlanet_radius * 2)

# вычисление геостационарной орбиты
func calculation_geostationary_orbit():
	var m: float = Settings.G * Settings.SystemPlanet_weight
	Settings.Geostationary_orbit = ((m * (Settings.SystemPlanet_turnover_period ** 2.)) / (4. * (PI ** 2.))) ** (1. / 3.)
	Settings.Geostationary_orbit /= 1000


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
	dir.make_dir("planet_presets") # настройки планет
	
	# создание стандартных настроек
	create_config_file()
	create_planet_presets()
	create_air_saturation_file()
	
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
		"Video_speed_idx" = 2,
		"Video_scale" = 150,
		"Video_image_idx" = 0,
		"Video_show_saturation" = true,
		"Video_stop_system" = false,
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
			"SystemPlanet_radius" = 6378.,
			"SystemPlanet_gravitation" = 9.807,
			"SystemPlanet_weight" = 5.972E24,
			"SystemPlanet_turnover_period" = 86400.0,
		}
		file.store_line(JSON.stringify(data))

# создание файла с данными по плотности воздуха (от 0 км до 20 км)
func create_air_saturation_file():
	var file = "res://data/air_saturation.txt"
	if FileAccess.file_exists(file): return
	file = FileAccess.open(file, FileAccess.WRITE)
	file.store_line("251204241917707.6 0.0\n228610658524441.88 1.0\n206657824318504.03 2.0
186096106492082.88 3.0\n167327880526692.12 4.0\n150501268062597.9 5.0
135475234991135.34 6.0\n121682205371253.05 7.0\n108709677235090.6 8.0
96366928180965.05 9.0\n84615073116823.6 10.0\n73552436492303.7 11.0
63458191685639.484 12.0\n54496928240198.5 13.0\n46701437395733.805 14.0
40021661494524.89 15.0\n34346534008737.004 16.0\n29500331718313.508 17.0
25333758190339.168 18.0\n21733518526801.78 19.0\n18612866225994.195 20.0")


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
