extends Node3D


func _process(_delta: float) -> void:
	# Поворот планеты
	if Settings.Video_speed > 0:
		rotation.y += -deg_to_rad((1.3 ** (Settings.Video_speed - 1)))
		# увеличесние счетчика дней при завершении круга
		while -rotation.y > 2 * PI:
			rotation.y += 2 * PI
			Settings.Day_counter += 1
			if Settings.Day_counter > 366: Settings.Day_counter = 0
			Settings.Changing_day_count = true # установка метки смены дня
