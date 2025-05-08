extends VBoxContainer

@onready var System = $"../../../../TextureRect/SubViewport/System"

@onready var UnitError = $Unit/Error
@onready var UnitType = $Unit/VBoxContainer/Type
@onready var UnitInclination = $Unit/VBoxContainer/Inclination
@onready var UnitAscendingNode = $Unit/VBoxContainer/AscendingNode

@onready var PackError = $Pack/Error

@onready var NetError = $Net/Error
@onready var NetStep = $Net/VBoxContainer/Step

const page_name: String = "добавление объектов🛰"


func _ready() -> void:
	# Изменение текстовых значений параметров
	for i in [UnitInclination, UnitAscendingNode]:
		i.get_child(0).set_text(str(int(i.value)) + "°")
		
	NetStep.get_child(0).set_text(str(int(NetStep.value)) + "км")


# изменение значения положения на окружности для единичного
func _on_unit_inclination_value_changed(value: int) -> void:
	UnitInclination.get_child(0).set_text(str(value) + "°")

# изменение значения высоты для единичного
func _on_unit_ascending_node_value_changed(value: int) -> void:
	UnitAscendingNode.get_child(0).set_text(str(value) + "°")

# изменение значения шага для сетки
func _on_net_step_value_changed(value: int) -> void:
	NetStep.get_child(0).set_text(str(value) + "км")


# вызов сигнала добавления объекта
func add_object(error, obj_name: String, radius: String, inclination, ascending_node):
	Settings.set_error(error)
	Settings.emit_signal("add_object", "res://scenes/objects/" + obj_name + ".tscn",
						 int(radius), inclination.value, ascending_node.value)


# добавление единичного объекта
func _on_unit_button_down() -> void:
	var radius: String = $Unit/VBoxContainer/Radius.get_text()
	const min_r: int = 300
	
	if not radius.is_valid_int() or int(radius) < min_r:
		Settings.set_error(UnitError, "радиус должен быть числом больше " + str(min_r))
	else:
		const objects = ["cubsat", "oneWeb", "lemur", "MKS"]
		add_object(UnitError, objects[UnitType.selected], radius, UnitInclination, UnitAscendingNode)

# добавление последовательности объектов
func _on_pack_button_down() -> void:
	var count: String = $Pack/VBoxContainer/Count.get_text()
	var start: String = $Pack/VBoxContainer/Start.get_text()
	var step: String = $Pack/VBoxContainer/Step.get_text()
	const min_start: int = 300
	const min_step: int = 10
	const min_count: int = 2
	
	if not count.is_valid_int() or not start.is_valid_int() or not step.is_valid_int():
		Settings.set_error(PackError, "Значения должны быть целыми числами")
	elif int(start) < min_start:
		Settings.set_error(PackError, "Отступ от центра должен быть больше " + str(min_start))
	elif int(step) < min_step:
		Settings.set_error(PackError, "Шаг должен быть больше " + str(min_step))
	elif int(count) < min_count:
		Settings.set_error(PackError, "Количество объектов должно быть больше " + str(min_count))
	else:
		Settings.set_error(PackError)
		for i in int(count):
			Settings.emit_signal("add_object", "res://scenes/objects/cubsat.tscn", int(start) + i * int(step), 0, 90)


# добавление сетки starlink
func _on_net_button_down() -> void:
	var start: String = $Net/VBoxContainer/Start.get_text()
	const min_start: int = 300
	if not start.is_valid_int() or int(start) < min_start:
		Settings.set_error(NetError, "Отступ от центра должен быть числом больше " + str(min_start))
	else:
		Settings.set_error(NetError)
		Settings.emit_signal("add_net", int(start), NetStep.value)
