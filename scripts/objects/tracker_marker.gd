extends Node3D

func _ready() -> void:
	# установка размера маркера
	var obj_size = get_parent().get_model_size()
	var torus_size = get_child(0).get_aabb().size
	var s = max(obj_size.x - torus_size.x, obj_size.z - torus_size.z)
	if s > 0:
		scale.x = ceil(s) / 2 + 1
		scale.z = scale.x		


func _process(_delta: float) -> void:
	rotation_degrees.x = Settings.VideoCamera_x
	rotation_degrees.y = Settings.VideoCamera_y
	position.x = get_parent().get_child(0).position.x
	position.y = get_parent().get_child(0).position.y
	position.z = get_parent().get_child(0).position.z
