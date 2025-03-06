extends VBoxContainer

@onready var Solar = $"../../../TextureRect/SubViewport/System/SpotLight3D"
@onready var MainActivity = $Main/VBoxContainer/Activity

func _ready() -> void:
	MainActivity.text = str(Settings.SolarActivity)


func _on_Main_button_down() -> void:
	var Message = $Main/Message
	if not MainActivity.text.is_valid_float():
		Settings.set_error(Message, "Значения должны быть числами!")
	elif float(MainActivity.text) <= 0:
		Settings.set_error(Message, "Значения должны быть больше нуля!")
	else:
		Settings.set_error(Message)
		Settings.SolarActivity = float(MainActivity.text)
		Solar.light_energy = float(MainActivity.text) + 1.5
		
