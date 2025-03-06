extends Node

const e: float = 1.

# настройки видео
var VideoSimulation_speed: int = 1
var VideoRotation_x: int = 270
var VideoRotation_y: int = 0
var VideoScale: int = 150

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
