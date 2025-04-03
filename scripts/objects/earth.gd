extends Node3D


func _process(delta: float) -> void:
	$Earth.rotate_y(-Settings.Video_speed/100.)
