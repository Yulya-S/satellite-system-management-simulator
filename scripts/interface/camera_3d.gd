extends Camera3D

@onready var Main = $"../../../../../"


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("developer_console"):
		get_tree().paused = not get_tree().paused
		if get_tree().paused == true:
			Main.add_child(load("res://scenes/interface/developer_console.tscn").instantiate())
		else:
			Main.get_child(-1).queue_free()
			Main.remove_child(Main.get_child(-1))
			
