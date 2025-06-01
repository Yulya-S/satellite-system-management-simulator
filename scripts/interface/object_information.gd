extends VBoxContainer

@onready var State = $Main/State/Label
@onready var TrackerImage = $Main/ColorRect/TextureRect
@onready var Type = $Main/Type
@onready var Radius = $Main/Information/Radius
@onready var Speed = $Main/Information/Speed
@onready var CircleCount = $Main/Information/CircleCount

@onready var HSchedule = $Measurements/VBoxContainer/HSchedule

var information_owner = null
var tracker = null


func _ready() -> void:
	get_parent().visible = false
	
	HSchedule.set_labels("время на орбите, дни", "высота орбиты, км")
	
	Settings.connect("add_tracker", Callable(self, "set_data"))
	Settings.connect("remove_tracker", Callable(self, "remove_information_owner"))


# изменение информации
func _process(_delta: float) -> void:
	if information_owner:
		Radius.set_text("радиус:    " + str(round(information_owner.get_real_h() * 100) / 100) + " км")
		Speed.set_text("скорость:    " + str(round(information_owner.get_real_speed() * 100) / 100) + " м/c")
		CircleCount.set_text("кол-во кругов:  " + str(information_owner.circle_count))
	else:
		Radius.set_text("")
		Speed.set_text("")
		CircleCount.set_text("")
	if tracker:	
		HSchedule.update_values(tracker.h_measurements)
		match tracker.obj_state:
			Settings.ObjectsStates.NORMAL: State.set_text("функционирует".to_upper())
			Settings.ObjectsStates.DESTROYED: State.set_text("не функционирует".to_upper())
			Settings.ObjectsStates.FELL: State.set_text("упал на планету".to_upper())


# получение статичных данных
func set_data(object):
	if information_owner: return
	
	information_owner = object.tracker_owner # установка зависимости с трекером
	tracker = object
	
	# замена изображения
	var file = "res://img/objects/" + tracker.owner_main_data[1] + ".jpg"
	if FileAccess.file_exists(file):
		TrackerImage.texture = load(file)
	
	# смена названия объекта
	tracker.owner_main_data[0][0] = tracker.owner_main_data[0][0].to_upper()
	Type.set_text(tracker.owner_main_data[0])
	get_parent().visible = true
	get_parent().get_parent().get_child(0).visible = false
	

# удаление связи с трекером
func remove_information_owner(object):
	if object != tracker: return
	information_owner = null
	tracker = null
	get_parent().visible = false
	get_parent().get_parent().get_child(0).visible = true


func _on_close_button_down() -> void:
	tracker.deleting_marker()
	tracker.tracker_fixation()
