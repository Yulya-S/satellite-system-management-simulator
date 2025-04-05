extends PopupPanel

@onready var ID = $ColorRect/ID
@onready var TrackerImage = $ColorRect/ColorRect/TextureRect
@onready var ObjType = $ColorRect/Type
@onready var Radius = $ColorRect/Radius
@onready var Speed = $ColorRect/Speed


func set_data(tracker_owner):
	position.x = 644.0 - size.x - 10
	position.y = 648.0 - size.y - 10
	
	# сохраняем ссылку на объект
	ID.set_text("id: " + str(tracker_owner.get_instance_id()))
	
	# получение типа объекта
	var type = tracker_owner.scene_file_path.split("/")[-1].split(".")[0]
	if type == "satelite_group":
		type = tracker_owner.get_child(0).scene_file_path.split("/")[-1].split(".")[0]
		
	TrackerImage.texture = load("res://img/" + type + ".jpg") # замена изображения
	
	# смена названия объекта
	match type:
		"cubsat": type = "кубсат"
		"lemur": type = "Лемур"
		"mks": type = "МКС"
	type[0] = type[0].to_upper()
	ObjType.set_text(type)
	
	
func set_text(object):
	Radius.set_text("радиус:    " + str(round(object.radius * 100) / 100))
	Speed.set_text("скорость:  " + str(round(object.speed * 100) / 100))
