extends CanvasLayer

@onready var System = $"../TextureRect/SubViewport/System/System"
@onready var Trackers = $"../CanvasLayer/Tracking/ScrollContainer/Tracking"
@onready var Text = $TextEdit
@onready var Message = $Message


func _ready() -> void: Text.grab_focus() # ставим фокус на текстовый контейнер


func _process(_delta: float) -> void:
	# ппроверяем ввод команды
	if Input.is_action_just_pressed("enter"):
		if Text.text != "":
			var command = Text.get_text().split(" ")
			command[-1] = command[-1].replace("\n", "")
			Text.text = ""
			run_command(command)


# Запуск команд
func run_command(command):
	Message.text += command[0] + "\t\t"
	match command[0]:
		"clear": clear_system()
		_: Message.text += "Попытка вызова несуществующей команды\n"
		

# команда удаления всех объектов системы
func clear_system():
	for i in Trackers.get_children(): i.delete_object()
	Message.text += "Орбитальная система была очищена\n"
