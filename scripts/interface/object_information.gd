extends Node2D

@onready var ID = $ColorRect/ID
@onready var TrackerImage = $ColorRect/ColorRect/TextureRect
@onready var ObjType = $ColorRect/Type
@onready var Radius = $ColorRect/Information/Radius
@onready var Speed = $ColorRect/Information/Speed
@onready var CircleCount = $ColorRect/Information/CircleCount

var information_owner = null


func _ready() -> void:
	visible = false
	Settings.connect("add_tracker", Callable(self, "set_data"))
	Settings.connect("remove_tracker", Callable(self, "remove_information_owner"))


# изменение информации
func _process(_delta: float) -> void:
	if information_owner:
		Radius.set_text("радиус:    " + str(round(information_owner.get_real_h() * 100) / 100) + " км")
		Speed.set_text("скорость:  " + str(round(information_owner.get_real_speed() * 100) / 100) + "  км/ч")
		CircleCount.set_text("кол-во кругов:  " + str(information_owner.circle_count))


# получение статичных данных
func set_data(object):
	if information_owner: return
	
	information_owner = object # установка зависимости с трекером
	ID.set_text("id: " + str(information_owner.get_instance_id())) # сохраняем id объекта
	
	# замена изображения
	var file = "res://img/objects/" + information_owner.model_name + ".jpg"
	if FileAccess.file_exists(file):
		TrackerImage.texture = load(file)
	
	# смена названия объекта
	information_owner.object_name[0] = information_owner.object_name[0].to_upper()
	ObjType.set_text(information_owner.object_name)
	visible = true
	

# удаление связи с трекером
func remove_information_owner(object):
	if object != information_owner: return
	information_owner = null
	visible = false
	
