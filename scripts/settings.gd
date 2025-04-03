extends Node

# сигналы
signal сhanging_Video_scale(value: int)
signal сhanging_Video_image_idx(idx: int)
signal сhanging_VideoCamera_x(value: int)
signal сhanging_VideoCamera_y(value: int)
signal сhanging_VideoImage_brightness(value: float)
signal сhanging_VideoImage_fog(value: float)

# константы
const e: float = 1.
const Environment_array = ["environment_1.jpg", "environment_2.jpg", "environment_3.jpg", "environment_4.jpg"]

# настройки видео
var Video_speed: int = 1
var Video_scale: int = 150
var Video_image_idx: int = 0

var VideoCamera_x: int = 270
var VideoCamera_y: int = 0

var VideoImage_brightness: float = 1.
var VideoImage_fog: float = 0.

# настройки Земли
var EarthGravity: float = 1.
var EarthWeight: float = 1.
# var EarthAirDensity: float = 1.225 # плотность воздуха
var EarthAccelerationOfGravity: float = 9.81 # Ускорение свободного падения

# Настройки солнца
var SolarActivity: float = 1.

# получить плотность воздуха в зависимости от растояния до объекта
func EarthAirDensity(height: float) -> float:
	const AtmosphereAltitude: float = 1.
	return SolarActivity * e ** (-height / AtmosphereAltitude)

# Применение текста при ошибке ввода
func set_error(message, text: String = ""):
	if text == "": message.text = ""
	else: message.text = "Ошибка ввода! " + text
