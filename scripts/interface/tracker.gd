extends ColorRect

@onready var TrackerLabel = $Label
@onready var Marker = $ColorRect/Marker


var tracker_owner = null


func set_tracker_owner(new_owner):
	# сохраняем ссылку на объект
	tracker_owner = new_owner
	TrackerLabel.set_text(str(tracker_owner.get_instance_id()).left(5))
	
	# получение типа объекта
	var color = Color.BROWN
	var type = tracker_owner.scene_file_path.split("/")[-1].split(".")[0]
	if type == "satelite_group":
		type = tracker_owner.get_child(0).scene_file_path.split("/")[-1].split(".")[0]
	
	# смена названия объекта
	match type:
		"cubsat": color = Color.AQUA
		"lemur": color = Color.DARK_BLUE
		"mks": color = Color.DIM_GRAY
		"oneWeb": color = Color.DARK_GOLDENROD
		"starlink": color = Color.DARK_GREEN
	Marker.color = color # установка цветового маркера
	

func _process(_delta: float) -> void:
	# обновление данных
	if tracker_owner == null: Marker.color = Color.BROWN
	elif get_child_count() > 3:
		var parent = tracker_owner
		if Marker.color == Color.DARK_GREEN: parent = tracker_owner.get_child(0)
		get_child(-1).set_text(parent)


func _on_mouse_entered() -> void:
	if tracker_owner != null:
		# добавляем окно информации
		add_child(load("res://scenes/interface/message.tscn").instantiate())
		get_child(-1).set_data(tracker_owner)
		# добавление выделения объекта
		tracker_owner.add_child(load("res://scenes/objects/torus.tscn").instantiate())


func _on_mouse_exited() -> void:
	# удаляем окно информации
	if get_child_count() > 3:
		get_child(-1).queue_free()
		remove_child(get_child(-1))
	# удаление выделения объекта
	if tracker_owner != null:
		tracker_owner.get_child(-1).queue_free()
		tracker_owner.remove_child(tracker_owner.get_child(-1))
