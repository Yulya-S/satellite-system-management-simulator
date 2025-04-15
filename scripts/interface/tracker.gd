extends Button

@onready var Marker = $Marker
@onready var Active = $Active

var tracker_owner = null # владелец трекера
var state = Settings.TrackerStates.NORMAL # состояние трекера


# создание свзи между трекером и объектом
func set_tracker_owner(new_owner):
	tracker_owner = new_owner # сохраняем ссылку на объект
	set_text(str(tracker_owner.get_instance_id())) # устанавливаем id объекта
	Marker.color = tracker_owner.color_marker # изменяем цвемовой маркер объекта
	

func _process(_delta: float) -> void:
	if not tracker_owner: Marker.color = Color.BROWN # обновление данных


# наведение курсора на трекер
func _on_mouse_entered() -> void:
	if state == Settings.TrackerStates.ACTIVE: return
	state = Settings.TrackerStates.HOVER
	if tracker_owner:
		Settings.emit_signal("add_tracker", tracker_owner) # привязываем окно информации
		# добавление выделения объекта
		tracker_owner.add_child(load("res://scenes/objects/tracker_marker.tscn").instantiate())


# курсор убран с трекера
func _on_mouse_exited() -> void:
	if state == Settings.TrackerStates.HOVER:
		Settings.emit_signal("remove_tracker", tracker_owner) # удаляеем связь с окном информации
		# удаление выделения объекта
		if tracker_owner:
			tracker_owner.get_child(-1).queue_free()
			tracker_owner.remove_child(tracker_owner.get_child(-1))
		state = Settings.TrackerStates.NORMAL


# удаление объекта и  трекера
func delete_object():
	if tracker_owner:
		tracker_owner.queue_free()
		tracker_owner.get_parent().remove_child(tracker_owner)
	queue_free()
	get_parent().remove_child(self)

# нажатие кнопки удаления
func _on_delete_button_down() -> void:
	if state == Settings.TrackerStates.ACTIVE:
		state = Settings.TrackerStates.HOVER
		_on_mouse_exited()
	delete_object()


# фиксация трекера
func _on_button_down() -> void:
	for i in get_parent().get_children():
		if i == self: continue
		if i.state == Settings.TrackerStates.ACTIVE: return
	if state == Settings.TrackerStates.HOVER: state = Settings.TrackerStates.ACTIVE
	else: state = Settings.TrackerStates.HOVER
	Active.visible = state == Settings.TrackerStates.ACTIVE
	
