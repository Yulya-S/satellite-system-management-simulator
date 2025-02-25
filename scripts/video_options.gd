extends VBoxContainer

@onready var System = $"../../../TextureRect/SubViewport/System"
@onready var CameraNode = $"../../../TextureRect/SubViewport/System/CameraNode"
@onready var Camera = $"../../../TextureRect/SubViewport/System/CameraNode/Camera3D"

@onready var SimulationSpeed = $Video/VBoxContainer/SimulationSpeed
@onready var RotationX = $Video/VBoxContainer/RotationX
@onready var RotationY = $Video/VBoxContainer/RotationY
@onready var Scale = $Video/VBoxContainer/Scale

@onready var AddingPositionOnCircle = $Adding/VBoxContainer/PositionOnCircle
@onready var AddingSpherePosY = $Adding/VBoxContainer/SpherePosY

@onready var AddSateliteGroupeStep = $Add_satelite_groupe/VBoxContainer/Step


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
	
	CameraNode.rotation_degrees.x = RotationX.value
	CameraNode.rotation_degrees.y = RotationY.value
	Camera.position.z = Scale.value
	
	# Изменение текстовых значений параметров
	SimulationSpeed.get_child(0).text = str(SimulationSpeed.value)
	RotationX.get_child(0).text = str(RotationX.value)
	RotationY.get_child(0).text = str(RotationY.value)
	Scale.get_child(0).text = str(Scale.value)
	AddingPositionOnCircle.get_child(0).text = str(AddingPositionOnCircle.value)
	AddingSpherePosY.get_child(0).text = str(AddingSpherePosY.value)
	AddSateliteGroupeStep.get_child(0).text = str(AddSateliteGroupeStep.value)
	


# изменение скорости симуляции
func _on_simulation_speed_value_changed(value: float) -> void:
	SimulationSpeed.get_child(0).text = str(value)
	Settings.VideoSimulation_speed = SimulationSpeed.value

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


# сброс настроек поворота
func _on_reset_turn_button_down() -> void:
	Settings.VideoRotation_x = 270
	Settings.VideoRotation_y = 0
	
	RotationX.value = Settings.VideoRotation_x
	RotationY.value = Settings.VideoRotation_y
	
	RotationX.get_child(0).text = str(RotationX.value)
	RotationY.get_child(0).text = str(RotationY.value)
	
	
# изменение значения положения на окружности в добавлении объекта
func _on_position_on_circle_value_changed(value: float) -> void:
	AddingPositionOnCircle.get_child(0).text = str(value)
	
# изменение значения высоты относительно сферы в добавлении объекта
func _on_sphere_pos_y_value_changed(value: float) -> void:
	AddingSpherePosY.get_child(0).text = str(value)

# добавление нового объекта
func _on_button_button_down() -> void:
	var Radius = $Adding/VBoxContainer/Radius.text
	var AddingMessage = $Adding/Message
	if not Radius.is_valid_int() or int(Radius) < 20:
		AddingMessage.text = "Радиус должен быть числом больше 20!"
		return
	System.add_new_object_in_system(int(Radius), int(AddingPositionOnCircle.value),
									int(AddingSpherePosY.value))
	AddingMessage.text = ""


# добавление пачки объектов
func _on_add_pack_button_down() -> void:
	var Count = $Add_pack/VBoxContainer/Count.text
	var StartValue = $Add_pack/VBoxContainer/Start_value.text
	var Step = $Add_pack/VBoxContainer/Step.text
	var AddPackMessage = $Add_pack/Message
	
	if not Count.is_valid_int() or not StartValue.is_valid_int() or not Step.is_valid_int():
		AddPackMessage.text = "Ошибка ввода! Значения должны быть целыми числами!"
		return
	if int(Count) <= 0 or int(StartValue) <= 0 or int(Step) <= 0:
		AddPackMessage.text = "Значения должны быть больше нуля!"
		return	
	if int(StartValue) < 20:
		AddPackMessage.text = "Растояние от центра должно быть больше или равно 10!"
		return
	if int(Step) < 5:
		AddPackMessage.text = "Шаг должн быть больше или равен 5!"
		return
	for i in int(Count):
		var r: int = int(StartValue) + i * int(Step)
		System.add_new_object_in_system(r, 0)
	AddPackMessage.text = ""


# изменение расстояния между объектами при добавлении 
func _on_step_value_changed(value: float) -> void:
	AddSateliteGroupeStep.get_child(0).text = str(value)


func _on_add_satelite_groupe_button_down() -> void:
	var StartValue = $Add_satelite_groupe/VBoxContainer/Start_value.text
	var Message = $Add_satelite_groupe/Message
	
	if not StartValue.is_valid_int() or int(StartValue) < 20:
		Message.text = "Отступ от центра должен быть числом больше 20!"
		return
		
	var scene = load("res://scenes/satelite_group.tscn")
	System.add_child(scene.instantiate())
	System.get_child(-1).calculate_group(int(AddSateliteGroupeStep.value), int(StartValue))
	Message.text = ""
