extends Node3D

func _ready() -> void:
	var radius = get_child(0).get_child(0).get_aabb().size[0] * get_child(0).scale[0]
	get_child(0).get_child(0).set_texture("earth_texture")
	Settings.Unit_distance = radius / (Settings.SystemPlanet_radius * 2)


func _process(_delta: float) -> void:
	if Settings.Video_speed > 0:
		rotation.y += -deg_to_rad((1.3 ** (Settings.Video_speed - 1)))
		
		while -rotation.y > 2 * PI:
			rotation.y += 2 * PI
			Settings.Day_counter += 1
			if Settings.Day_counter > 366: Settings.Day_counter = 0
			Settings.Changing_day_count = true
