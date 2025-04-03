extends CanvasLayer
@onready var system = $"../TextureRect/SubViewport/System/System"

func _ready() -> void:
	$TextEdit.grab_focus()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("enter"):
		if $TextEdit.text != "":
			var command = $TextEdit.text.split(" ")
			command[-1] = command[-1].replace("\n", "")
			$TextEdit.text = ""
			run_command(command)	


# Запуск команд
func run_command(command):
	match command[0]:
		"clear": clear_system()
		_: $RichTextLabel.text += "Попытка вызова несуществующей команды!\n"
		

# очистка системы
func clear_system():
	for i in system.get_children():
		i.queue_free()
		system.remove_child(i)
	$RichTextLabel.text += "Орбитальная система была очищена!\n"
