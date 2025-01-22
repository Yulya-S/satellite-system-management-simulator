extends CanvasLayer
@onready var system = $"../../../system"

func _ready() -> void:
	$TextEdit.grab_focus()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("enter"):
		if $TextEdit.text != "":
			var command = $TextEdit.text.split(" ")
			command[-1] = command[-1].replace("\n", "")
			$TextEdit.text = ""
			run_command(command)	

func run_command(command):
	match command[0]:
		"add": add_objects(command)
		_: $RichTextLabel.text += "Попытка вызова несуществующей команды!\n"

func add_objects(data):
	var radius = -1
	if len(data) > 1 and data[1].is_valid_int() and int(data[1]) >= 50: radius = int(data[1])
	var t = -1
	if len(data) > 2 and data[2].is_valid_int(): t = int(data[2])
	system.new_child(radius, t)
	$RichTextLabel.text += "Был добавлен новый объект!\n"
