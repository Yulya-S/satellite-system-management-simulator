extends Node3D
@onready var count = $"../CameraNode/Camera3D/CanvasLayer/count"
@onready var speed_multiplier = $"../CameraNode/Camera3D/CanvasLayer/speed"
@export var mod: bool = false # создание объектов в одной точке или в рандомных

func _ready() -> void:
	var cubsat = load("res://objects/cubsat.tscn")
	
	if not mod:
		for i in range(count.value):
			add_child(cubsat.instantiate())
			get_children()[-1].speed_multiplier = speed_multiplier.value
	else:
		pass


func _process(delta: float) -> void:
	pass

# изменение количества объектов
func _on_count_drag_ended(value_changed: bool) -> void:
	if value_changed:
		if len(get_children()) < count.value:
			var cubsat = load("res://objects/cubsat.tscn")
			while len(get_children()) < count.value:
				add_child(cubsat.instantiate())
				get_children()[-1].speed_multiplier = speed_multiplier.value
		else:
			while len(get_children()) > count.value:
				remove_child(get_children()[-1])

# изменение скорости симуляции
func _on_speed_drag_ended(value_changed: bool) -> void:
	if value_changed:
		for i in get_children():
			i.speed_multiplier = speed_multiplier.value
