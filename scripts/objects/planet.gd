extends Node3D

@onready var north_south = $WindRose/NorthSouth
@onready var west_east = $WindRose/WestEast


func _process(delta: float) -> void:
	# Поворот планеты
	if not Settings.Video_stop_system:
		rotation.y += deg_to_rad((360. * delta) / Settings.Video_speed)
		# увеличесние счетчика дней при завершении круга
		if rotation.y > 2 * PI:
			Settings.Day_counter += floor(rotation.y / (2. * PI))
			if Settings.Day_counter > 366: Settings.Day_counter -= 366
			rotation.y -= (2. * PI) * floor(rotation.y / (2. * PI))
			
	north_south.rotation.y = -rotation.y + deg_to_rad(Settings.VideoCamera_y)
	north_south.get_child(0).rotation.x = deg_to_rad(Settings.VideoCamera_x)
	north_south.get_child(1).rotation.x = deg_to_rad(Settings.VideoCamera_x)
	
	west_east.rotation.y = -rotation.y + deg_to_rad(Settings.VideoCamera_y)
	west_east.rotation.x = deg_to_rad(Settings.VideoCamera_x)
	
