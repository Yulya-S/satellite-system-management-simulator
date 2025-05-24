extends Button

@onready var Marker = $Marker
@onready var Active = $Active

var tracker_owner = null # владелец трекера
var owner_main_data = []

var state = Settings.TrackerStates.NORMAL # состояние трекера
var obj_state = Settings.ObjectsStates.NORMAL

var speed_measurements = []
var h_measurements = []

# создание свзи между трекером и объектом
func set_tracker_owner(new_owner):
	tracker_owner = new_owner # сохраняем ссылку на объект
	# резервная копия данных об объекте (на случай разрушения объекта)
	owner_main_data = []
	owner_main_data.append(tracker_owner.object_name)
	owner_main_data.append(tracker_owner.model_name)
	
	set_text(str(tracker_owner.get_instance_id())) # устанавливаем id объекта
	Marker.color = tracker_owner.color_marker # изменяем цвемовой маркер объекта
	new_owner.tracker = self
	

func _process(_delta: float) -> void:
	if not tracker_owner: Marker.color = Color.BROWN # обновление данных


# наведение курсора на трекер
func _on_mouse_entered() -> void:
	if state == Settings.TrackerStates.ACTIVE: return
	state = Settings.TrackerStates.HOVER
	if tracker_owner:
		# добавление выделения объекта
		tracker_owner.add_child(load("res://scenes/objects/tracker_marker.tscn").instantiate())


# удаление маркера объекта
func deleting_marker() -> void:
	if tracker_owner:
		tracker_owner.get_child(-1).queue_free()
		tracker_owner.remove_child(tracker_owner.get_child(-1))


# курсор убран с трекера
func _on_mouse_exited() -> void:
	if state == Settings.TrackerStates.HOVER:
		deleting_marker()
		state = Settings.TrackerStates.NORMAL


# нажатие кнопки удаления
func _on_delete_button_down() -> void:
	if state == Settings.TrackerStates.ACTIVE:
		state = Settings.TrackerStates.HOVER
	if tracker_owner:
		tracker_owner.queue_free()
		tracker_owner.get_parent().remove_child(tracker_owner)
	Settings.emit_signal("remove_tracker", self) # отвязываем окно информации
	queue_free()
	get_parent().remove_child(self)

# фиксация трекера
func tracker_fixation() -> void:
	for i in get_parent().get_children():
		if i == self: continue
		if i.state == Settings.TrackerStates.ACTIVE: return
	if state == Settings.TrackerStates.HOVER:
		state = Settings.TrackerStates.ACTIVE
		Settings.emit_signal("add_tracker", self) # привязываем окно информации
	else:
		state = Settings.TrackerStates.HOVER
		Settings.emit_signal("remove_tracker", self) # отвязываем окно информации
	Active.visible = state == Settings.TrackerStates.ACTIVE


# фиксация трекера
func _on_tracker_button_down() -> void:
	tracker_fixation()
