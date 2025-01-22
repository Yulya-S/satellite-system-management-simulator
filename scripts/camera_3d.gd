extends Camera3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("developer_console"):
		get_tree().paused = not get_tree().paused
		if get_tree().paused == true:
			add_child(load("res://developer_console.tscn").instantiate())
		else:
			remove_child(get_child(1))
