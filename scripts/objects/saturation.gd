extends Node2D


func _ready() -> void: Settings.connect("changing_Video_show_saturation", Callable(self, "_changing_saturation"))


# отрисовка колец плотности воздуха
func _draw() -> void:
	if not Settings.Video_show_saturation: return # отмена отрисовки
	
	var center = get_parent().size / 2 # центр системы
	var last_value = -1
	var video_scale = (200. / Settings.Video_scale)
	
	var max_value = Settings.saturation.values().max()
	
	# проход по данным о плотности воздуха
	for i in Settings.saturation.keys():
		var radius = (i + Settings.SystemPlanet_radius) * Settings.Unit_distance * video_scale * 1.85
		if radius - last_value > 4. / video_scale:
			draw_circle(center, radius, Color.from_rgba8((Settings.saturation[i] * 255.) / max_value, 255, 255, 100), false)
			last_value = radius


# перезапуск отрисовки колец
func _changing_saturation(): queue_redraw()
	
