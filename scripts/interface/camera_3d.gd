extends Camera3D

@onready var Main = $"../../../../../"


func _ready() -> void:
	Settings.connect("сhanging_Video_scale", Callable(self, "_сhanging_Video_scale"))
	Settings.connect("сhanging_VideoCamera_x", Callable(self, "_сhanging_VideoCamera_x"))
	Settings.connect("сhanging_VideoCamera_y", Callable(self, "_сhanging_VideoCamera_y"))
	
	_сhanging_Video_scale(Settings.Video_scale)
	_сhanging_VideoCamera_x(Settings.VideoCamera_x)
	_сhanging_VideoCamera_y(Settings.VideoCamera_y)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("developer_console"):
		get_tree().paused = not get_tree().paused
		if get_tree().paused == true:
			Main.add_child(load("res://scenes/interface/developer_console.tscn").instantiate())
		else:
			Main.get_child(-1).queue_free()
			Main.remove_child(Main.get_child(-1))
			

func _сhanging_Video_scale(value: int): position.z = value

func _сhanging_VideoCamera_x(value: int): get_parent().rotation_degrees.x = value

func _сhanging_VideoCamera_y(value: int): get_parent().rotation_degrees.y = value


			

			
