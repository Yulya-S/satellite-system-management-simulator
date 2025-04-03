extends Node

# сигналы
signal сhanging_environment(idx: int)
signal сhanging_environment_brightness(value: float)
signal сhanging_environment_FOV(value: int)

# константы
const e: float = 1.
const Environment_array = ["environment_1.jpg", "environment_2.jpg", "environment_3.jpg", "environment_4.jpg"]

# настройки видео
var VideoSimulation_speed: int = 1
var VideoRotation_x: int = 270
var VideoRotation_y: int = 0
var VideoScale: int = 150

# настройки окружения
var Environment_idx: int = 0
var Environment_brightness: float = 1.
var Environment_FOV: int = 0

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
