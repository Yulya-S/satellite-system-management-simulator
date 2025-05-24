extends VBoxContainer

@onready var System = $"../../../../TextureRect/SubViewport/System"

@onready var UnitError = $Unit/Error
@onready var UnitType = $Unit/VBoxContainer/Type
@onready var UnitWeight = $Unit/VBoxContainer/Weight
@onready var UnitCrossSectionalArea = $Unit/VBoxContainer/CrossSectionalArea

@onready var PackError = $Pack/Error

@onready var NetError = $Net/Error
@onready var NetStep = $Net/VBoxContainer/Step

const page_name: String = "добавление объектов🛰"


func _ready() -> void:
	# Изменение текстовых значений параметров
	NetStep.get_child(0).set_text(str(int(NetStep.value)) + "км")


# замена массы и площади поперечного сечения при смене типа спутника
func _on_unit_type_item_selected(index: int) -> void:
	var values = Settings.satelites_info[UnitType.get_item_text(index)]
	UnitWeight.set_text(str(values.weight))
	UnitCrossSectionalArea.set_text(str(values.cross_sectional_area))


# изменение значения шага для сетки
func _on_net_step_value_changed(value: int) -> void:
	NetStep.get_child(0).set_text(str(value) + "км")


# вызов сигнала добавления объекта
func add_object(error, obj_name: String, radius: String, weight: String, cross_sectional_area: String,
				inclination: String, ascending_node: String):
	Settings.set_error(error)
	Settings.emit_signal("add_object", "res://scenes/objects/" + obj_name + ".tscn",
						 float(radius), float(weight), float(cross_sectional_area), float(inclination), float(ascending_node))


# добавление единичного объекта
func _on_unit_button_down() -> void:
	var radius: String = $Unit/VBoxContainer/Radius.get_text()
	var weight: String = UnitWeight.get_text()
	var cross_sectional_area: String = UnitCrossSectionalArea.get_text()
	var inclination: String = $Unit/VBoxContainer/Inclination.get_text()
	var ascending_node: String = $Unit/VBoxContainer/AscendingNode.get_text()
	const min_r: float = 150.
	const min_w: float = 0.
	const min_c: float = 0.
	const min_i: float = 0.
	const max_i: float = 180.
	const min_a: float = 0.
	const max_a: float = 360.
	
	if weight == "": weight = "0."
	if cross_sectional_area == "": cross_sectional_area = "0."
	
	if not weight.is_valid_float() or not radius.is_valid_float() or not inclination.is_valid_float() \
	   or not ascending_node.is_valid_float() or not cross_sectional_area.is_valid_float():
		Settings.set_error(UnitError, "все переменные должен быть числами")
	elif float(weight) < min_w:
		Settings.set_error(UnitError, "вес спутника должен быть числом больше " + str(min_w))
	elif float(cross_sectional_area) < min_c:
		Settings.set_error(UnitError, "площадь поперечного сечения спутника должена быть числом больше " + str(min_c))
	elif float(radius) < min_r:
		Settings.set_error(UnitError, "радиус должен быть числом больше или равно " + str(min_r))
	elif float(inclination) < min_i or float(inclination) > max_i:
		Settings.set_error(UnitError, "наклонение должно находиться в диаппазоне от " + str(min_i) + " до " + str(max_i))
	elif float(ascending_node) < min_a or float(ascending_node) > max_a:
		Settings.set_error(UnitError, "долгота восходящего узла должна находиться в диаппазоне от " + str(min_a) + " до " + str(max_a))
	else:
		const objects = ["cubsat", "oneWeb", "lemur", "MKS"]
		add_object(UnitError, objects[UnitType.selected], radius, weight, cross_sectional_area, inclination, ascending_node)

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
			Settings.emit_signal("add_object", "res://scenes/objects/cubsat.tscn", int(start) + i * int(step), 0., 0., 0., 90.)


# добавление сетки starlink
func _on_net_button_down() -> void:
	var start: String = $Net/VBoxContainer/Start.get_text()
	const min_start: int = 300
	if not start.is_valid_int() or int(start) < min_start:
		Settings.set_error(NetError, "Отступ от центра должен быть числом больше " + str(min_start))
	else:
		Settings.set_error(NetError)
		Settings.emit_signal("add_net", int(start), NetStep.value)
