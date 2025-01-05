extends Node3D
@onready var speed_multiplier = $"../CameraNode/Camera3D/CanvasLayer/speed"

func _ready() -> void:
	pass
	#new_child()

func _process(delta: float) -> void:
	pass

# изменение скорости симуляции
func _on_speed_drag_ended(value_changed: bool) -> void:
	if value_changed:
		for i in get_children():
			i.speed_multiplier = speed_multiplier.value

# добавление нового объекта
func new_child(radius = -1, t = -1):
	var cubsat = load("res://objects/cubsat.tscn")
	add_child(cubsat.instantiate())
	get_child(-1).calculation_parameters(radius, t)
	get_child(-1).speed_multiplier = speed_multiplier.value
