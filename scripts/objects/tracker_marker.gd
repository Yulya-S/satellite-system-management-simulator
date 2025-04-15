extends Node3D

func _ready() -> void:
	# установка размера маркера
	if get_parent().scene_file_path.split("/")[-1].split(".")[0] == "satelite_group":
		scale.x = get_parent().get_child(0).radius / 2
		scale.z = scale.x
	else:
		var obj_size = get_parent().get_child(0).get_child(0).get_aabb().size
		var torus_size = get_child(0).get_aabb().size
		var s = max(obj_size.x - torus_size.x, obj_size.z - torus_size.z)
		if s > 0:
			scale.x = ceil(s) / 2 + 1
			scale.z = scale.x		


func _process(_delta: float) -> void:
	rotation_degrees.x = Settings.VideoCamera_x - 90
	rotation_degrees.y = Settings.VideoCamera_y
