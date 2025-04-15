extends ColorRect

@onready var TrackerLabel = $Label
@onready var Marker = $ColorRect/Marker

var tracker_owner = null


func set_tracker_owner(new_owner):
	# сохраняем ссылку на объект
	tracker_owner = new_owner
	TrackerLabel.set_text(str(tracker_owner.get_instance_id()).left(5))
	
	var type = tracker_owner.model_name # получение типа объекта
	var marker_color = tracker_owner.color_marker # получение цветового маркера
	Marker.color = marker_color # установка цветового маркера
	

func _process(_delta: float) -> void:
	# обновление данных
	if not tracker_owner: Marker.color = Color.BROWN
	elif get_child_count() > 3:
		var parent = tracker_owner
		if Marker.color == Color.DARK_GREEN: parent = tracker_owner.get_child(0)
		get_child(-1).set_text(parent)


func _on_mouse_entered() -> void:
	if tracker_owner:
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
	if tracker_owner:
		tracker_owner.get_child(-1).queue_free()
		tracker_owner.remove_child(tracker_owner.get_child(-1))


func delete_object():
	if tracker_owner:
		tracker_owner.queue_free()
		tracker_owner.get_parent().remove_child(tracker_owner)
	queue_free()
	get_parent().remove_child(self)

func _on_button_down() -> void: delete_object()
	
