extends VBoxContainer

@onready var UnitError = $Unit/Error
@onready var UnitType = $Unit/VBoxContainer/Type
@onready var UnitPositionOnCircle = $Unit/VBoxContainer/PositionOnCircle
@onready var UnitY = $Unit/VBoxContainer/Y

@onready var UniqueError = $Unique/Error
@onready var UniqueType = $Unique/VBoxContainer/Type
@onready var UniquePositionOnCircle = $Unique/VBoxContainer/PositionOnCircle
@onready var UniqueY = $Unique/VBoxContainer/Y

@onready var PackError = $Pack/Error

@onready var NetError = $Net/Error
@onready var NetStep = $Net/VBoxContainer/Step

const page_name: String = "добавление объектов"


func _ready() -> void:
	# Изменение текстовых значений параметров
	for i in [UnitPositionOnCircle, UnitY, UniquePositionOnCircle, UniqueY, NetStep]:
		i.get_child(0).set_text(str(int(i.value)))


# изменение значения положения на окружности для единичного
func _on_unit_position_on_circle_value_changed(value: int) -> void:
	UnitPositionOnCircle.get_child(0).set_text(str(value))

# изменение значения высоты для единичного
func _on_unit_y_value_changed(value: int) -> void:
	UnitY.get_child(0).set_text(str(value))

# изменение значения положения на окружности для уникального
func _on_unique_position_on_circle_value_changed(value: int) -> void:
	UniquePositionOnCircle.get_child(0).set_text(str(value))

# изменение значения высоты для уникального
func _on_unique_y_value_changed(value: int) -> void:
	UniqueY.get_child(0).set_text(str(value))
	
# изменение значения шага для сетки
func _on_net_step_value_changed(value: int) -> void:
	NetStep.get_child(0).set_text(str(value))


# вызов сигнала добавления объекта
func add_object(error, obj_name: String, radius: String, position_on_circle, y):
	Settings.set_error(error)
	Settings.emit_signal("add_object", "res://scenes/objects/" + obj_name + ".tscn",
						 int(radius), position_on_circle.value, y.value)


# добавление единичного объекта
func _on_unit_button_down() -> void:
	var radius: String = $Unit/VBoxContainer/Radius.get_text()
	const min_r: int = 20
	
	if not radius.is_valid_int() or int(radius) < min_r:
		Settings.set_error(UnitError, "Радиус должен быть числом больше " + str(min_r))
	else:
		const objects = ["cubsat", "oneWeb"]
		add_object(UnitError, objects[UnitType.selected], radius, UnitPositionOnCircle, UnitY)
		
# Нужно сюда внести отслеживание наличия такого объекта в системе
# добавление уникального объекта
func _on_unique_button_down() -> void:
	var radius: String = $Unique/VBoxContainer/Radius.get_text()
	const min_r: int = 60
	
	if not radius.is_valid_int() or int(radius) < min_r:
		Settings.set_error(UnitError, "Радиус должен быть числом больше " + str(min_r))
	else:
		const objects = ["mks", "lemur"]
		add_object(UniqueError, objects[UniqueType.selected], radius, UniquePositionOnCircle, UniqueY)


# добавление последовательности объектов
func _on_pack_button_down() -> void:
	var count: String = $Pack/VBoxContainer/Count.get_text()
	var start: String = $Pack/VBoxContainer/Start.get_text()
	var step: String = $Pack/VBoxContainer/Step.get_text()
	const min_start: int = 20
	const min_step: int = 5
	
	if not count.is_valid_int() or not start.is_valid_int() or not step.is_valid_int():
		Settings.set_error(PackError, "Значения должны быть целыми числами")
	elif int(count) <= 0 or int(start) <= 0 or int(step) <= 0:
		Settings.set_error(PackError, "Значения должны быть больше нуля")
	elif int(start) < min_start:
		Settings.set_error(PackError, "Отступ от центра должен быть больше " + str(min_start))
	elif int(step) < min_step:
		Settings.set_error(PackError, "Шаг должен быть больше " + str(min_step))
	else:
		Settings.set_error(PackError)
		for i in int(count):
			Settings.emit_signal("add_object", "res://scenes/objects/cubsat.tscn", int(start) + i * int(step), 0, 90)


# добавление сетки starlink
func _on_net_button_down() -> void:
	var start: String = $Net/VBoxContainer/Start.get_text()
	const min_start: int = 20
	if not start.is_valid_int() or int(start) < min_start:
		Settings.set_error(NetError, "Отступ от центра должен быть числом больше " + str(min_start))
	else:
		Settings.set_error(NetError)
		Settings.emit_signal("add_net", int(start), NetStep.value)
