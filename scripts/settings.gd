extends Node

# настройки видео
var VideoSimulation_speed: int = 1
var VideoRotation_x: int = 270
var VideoRotation_y: int = 0
var VideoScale: int = 150

# настройки Земли
var EarthGravity: float = 1.
var EarthWeight: float = 1.


# Применение текста при ошибке ввода
func set_error(message, text: String = ""):
	if text == "": message.text = ""
	else: message.text = "Ошибка ввода! " + text
