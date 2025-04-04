extends Node3D


func _process(_delta: float) -> void:
	if Settings.Video_speed > 0:
		rotate_y(-deg_to_rad((1.3 ** (Settings.Video_speed - 1))))
