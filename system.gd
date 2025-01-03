extends Node3D
@onready var count = $"../CameraNode/Camera3D/CanvasLayer/count"
@onready var speed_multiplier = $"../CameraNode/Camera3D/CanvasLayer/speed"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var cubsat = load("res://objects/cubsat.tscn")
	for i in range(count.value):
		add_child(cubsat.instantiate())
		get_children()[-1].speed_multiplier = speed_multiplier.value

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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
			
func _on_speed_drag_ended(value_changed: bool) -> void:
	if value_changed:
		for i in get_children():
			i.speed_multiplier = speed_multiplier.value
