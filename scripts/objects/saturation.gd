extends Node2D


func _ready() -> void: Settings.connect("changing_Video_show_saturation", Callable(self, "_changing_saturation"))


# отрисовка колец плотности воздуха
func _draw() -> void:
	if not Settings.Video_show_saturation: return
	
	var center = get_parent().size / 2
	var last_value = -1
	# проход по данным о плотности воздуха
	for i in Settings.saturation.keys():
		var radius = (i + Settings.SystemPlanet_radius) * Settings.Unit_distance * (200. / Settings.Video_scale) * 1.85
		if radius - last_value > 4. / (200. / Settings.Video_scale):
			draw_circle(center, radius, Color.from_rgba8(255 - Settings.saturation[i] / Settings.Unit_distance, 255, 255, 100), false)
			last_value = radius


func _changing_saturation():
	queue_redraw()
	
