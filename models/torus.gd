extends Node3D


func _process(_delta: float) -> void:
	rotation_degrees.x = Settings.VideoCamera_x - 90
	rotation_degrees.y = Settings.VideoCamera_y
