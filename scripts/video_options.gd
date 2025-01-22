extends VBoxContainer

@onready var System = $"../../../TextureRect/SubViewport/System"
@onready var CameraNode = $"../../../TextureRect/SubViewport/System/CameraNode"
@onready var Camera = $"../../../TextureRect/SubViewport/System/CameraNode/Camera3D"

@onready var SimulationSpeed = $Video/VBoxContainer/SimulationSpeed
@onready var RotationX = $Video/VBoxContainer/RotationX
@onready var RotationY = $Video/VBoxContainer/RotationY
@onready var Scale = $Video/VBoxContainer/Scale

@onready var Radius = $Adding/VBoxContainer/Radius
@onready var PositionOnCircle = $Adding/VBoxContainer/PositionOnCircle
@onready var AddingMessage = $Adding/Message

@onready var Count = $Add_pack/VBoxContainer/Count
@onready var StartValue = $Add_pack/VBoxContainer/Start_value
@onready var Step = $Add_pack/VBoxContainer/Step
@onready var AddPackMessage = $Add_pack/Message


func _ready() -> void:
	# применение шага изменения параметров отображения симуляции
	var factor: int = 5
	RotationX.step = factor
	RotationY.step = factor
	Scale.step = factor
	
	# получение значений из файла настроек
	SimulationSpeed.value = Settings.VideoSimulation_speed
	RotationX.value = Settings.VideoRotation_x
	RotationY.value = Settings.VideoRotation_y
	Scale.value = Settings.VideoScale
	
	# Изменение текстовых значений параметров
	SimulationSpeed.get_child(0).text = str(SimulationSpeed.value)
	RotationX.get_child(0).text = str(RotationX.value)
	RotationY.get_child(0).text = str(RotationY.value)
	Scale.get_child(0).text = str(Scale.value)


# изменение скорости симуляции
func _on_simulation_speed_value_changed(value: float) -> void:
	SimulationSpeed.get_child(0).text = str(value)
	Settings.VideoSimulation_speed = value

# изменение поворота системы по X
func _on_rotation_x_value_changed(value: float) -> void:
	RotationX.get_child(0).text = str(value)
	Settings.VideoRotation_x = value
	CameraNode.rotation_degrees.x = value

# изменение поворота системы по Y
func _on_rotation_y_value_changed(value: float) -> void:
	RotationY.get_child(0).text = str(value)
	Settings.VideoRotation_y = value
	CameraNode.rotation_degrees.y = value
	

# изменение масштаба системы
func _on_scale_value_changed(value: float) -> void:
	Scale.get_child(0).text = str(value)
	Settings.VideoScale = value
	Camera.position.z = value


func _on_reset_turn_button_down() -> void:
	Settings.VideoRotation_x = 270
	Settings.VideoRotation_y = 0
	
	RotationX.value = Settings.VideoRotation_x
	RotationY.value = Settings.VideoRotation_y
	
	RotationX.get_child(0).text = str(RotationX.value)
	RotationY.get_child(0).text = str(RotationY.value)
	

# добавление нового объекта
func _on_button_button_down() -> void:
	if Radius.text.is_valid_int() and PositionOnCircle.text.is_valid_int():
		System.add_new_object_in_system(int(Radius.text), int(PositionOnCircle.text))
		AddingMessage.text = ""
	else: AddingMessage.text = "Ошибка ввода! Значения должны быть целыми числами!"


# добавление пачки объектов
func _on_add_pack_button_down() -> void:
	if Count.text.is_valid_int() and StartValue.text.is_valid_int() and \
	   Step.text.is_valid_int():
		for i in int(Count.text):
			var r: int = int(StartValue.text) + i * int(Step.text)
			System.add_new_object_in_system(r, 0)
		AddPackMessage.text = ""
	else: AddPackMessage.text = "Ошибка ввода! Значения должны быть целыми числами!"
