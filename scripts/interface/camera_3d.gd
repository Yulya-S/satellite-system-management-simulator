extends Camera3D


func _ready() -> void:
	# подключение сигналов
	Settings.connect("changing_Video_scale", Callable(self, "_changing_Video_scale"))
	Settings.connect("changing_VideoCamera_x", Callable(self, "_changing_VideoCamera_x"))
	Settings.connect("changing_VideoCamera_y", Callable(self, "_changing_VideoCamera_y"))
	
	# получение старовых данных
	_changing_Video_scale(Settings.Video_scale)
	_changing_VideoCamera_x(Settings.VideoCamera_x)
	_changing_VideoCamera_y(Settings.VideoCamera_y)
			
			
# изменение приближения камеры
func _changing_Video_scale(value: int): position.z = value

# изменение поворота камеры по x
func _changing_VideoCamera_x(value: int): get_parent().rotation_degrees.x = value

# изменение поворота камеры по y
func _changing_VideoCamera_y(value: int): get_parent().rotation_degrees.y = value


			

			
