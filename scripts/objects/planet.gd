extends Node3D

func _process(delta: float) -> void:
	# Поворот планеты
	if not Settings.Video_stop_system:
		rotation.y -= deg_to_rad((360. * delta) / [60., 30., 1., 0.5][Settings.Video_speed_idx])
		# увеличесние счетчика дней при завершении круга
		if -rotation.y > 2 * PI:
			Settings.Day_counter += floor(-rotation.y / (2. * PI))
			if Settings.Day_counter > 366: Settings.Day_counter -= 366
			rotation.y += (2. * PI) * floor(-rotation.y / (2. * PI))
