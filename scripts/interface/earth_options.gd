extends VBoxContainer

@onready var MainGravitation = $Main/VBoxContainer/Gravitation
@onready var MainWeight = $Main/VBoxContainer/Weight


func _ready() -> void:
	MainGravitation.text = str(Settings.EarthGravity)
	MainWeight.text = str(Settings.EarthWeight)


func _on_Main_button_down() -> void:
	var Message = $Main/Message
	if not MainGravitation.text.is_valid_float() or not MainWeight.text.is_valid_float():
		Settings.set_error(Message, "Значения должны быть числами!")
	elif float(MainGravitation.text) <= 0 or float(MainWeight.text) <= 0:
		Settings.set_error(Message, "Значения должны быть больше нуля!")
	else:
		Settings.set_error(Message)
		Settings.EarthGravity = float(MainGravitation.text)
		Settings.EarthWeight = float(MainWeight.text)
