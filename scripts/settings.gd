extends Node

# сигналы
signal changing_Video_scale(value: int)
signal changing_Video_image_idx(idx: int)
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
const Environment_array = ["environment_1.jpg", "environment_2.jpg", "environment_3.jpg"]


# изменяемые значения
# настройки видео
var Video_speed: int = 1
var Video_scale: int = 150
var Video_image_idx: int = 0

var VideoCamera_x: int = 270
var VideoCamera_y: int = 0

var VideoImage_brightness: float = 1.
var VideoImage_fog: float = 0.
var VideoImage_color: Color = Color.WHITE

# настройки планетарной системы
var SystemPlanet_gravitation: float = 1. #6.674 * (10 ** -11)
var SystemPlanet_weight: float = 1. # 5.972 * (10 ** 24)
var SystemPlanet_acceleration: float = 9.81 # Ускорение свободного падения
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
