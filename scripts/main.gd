extends Node2D

@onready var Planet = $TextureRect/SubViewport/System/Planet

@onready var FPS = $CanvasLayer/FPS
@onready var PageName = $CanvasLayer/Interface/PageName/Label
@onready var InterfaceContainer = $CanvasLayer/Interface/InterfaceContainer
@onready var DayCounter = $CanvasLayer/DayCounter
@onready var Pause = $CanvasLayer/DayCounter/Pause

# страницы настроек
const pages = ["video_options", "adding_objects", "planetary_system_options"]
var page_index: int = 0


func _ready() -> void:
	Settings.create_dir() # создание папки с данными
	
	# пересчет значений нужных для вычисления скорости движения объектов
	Settings.calculation_unit_distance(Planet)
	Settings.calculation_geostationary_orbit()
	
	Settings.emit_signal("changing_Video_image_idx", Settings.Video_image_idx)
	InterfaceContainer.add_child(load("res://scenes/interface/" + pages[page_index] + ".tscn").instantiate())
	PageName.set_text(InterfaceContainer.get_child(0).page_name.to_upper())
	
	if Settings.Video_stop_system: Pause.text = "ЗАПУСК".to_upper()
	else: Pause.text = "ПАУЗА".to_upper()


func _process(_delta: float) -> void:
	# отображение количества кадров в секунду
	FPS.set_text("FPS: " + str(Performance.get_monitor(Performance.TIME_FPS)))
	DayCounter.set_text("день: " + str(Settings.Day_counter))
	
	# обработка запука консоли разработчика
	if Input.is_action_just_pressed("developer_console"):
		get_tree().paused = not get_tree().paused
		if get_tree().paused == true:
			add_child(load("res://scenes/interface/developer_console.tscn").instantiate())
		else:
			get_child(-1).queue_free()
			remove_child(get_child(-1))
	
	if Settings.Video_stop_system: Pause.text = "ЗАПУСК".to_upper()
	else: Pause.text = "ПАУЗА".to_upper()


# смена страницы настроек
func _set_page() -> void:
	InterfaceContainer.get_child(0).queue_free()
	InterfaceContainer.remove_child(InterfaceContainer.get_child(0))
	InterfaceContainer.add_child(load("res://scenes/interface/" + pages[page_index] + ".tscn").instantiate())
	PageName.set_text(InterfaceContainer.get_child(0).page_name.to_upper())


# смена страницы влево
func _on_left_button_down() -> void:
	page_index -= 1
	if page_index < 0: page_index = len(pages) - 1
	_set_page()

# смена страницы вправо
func _on_right_button_down() -> void:
	page_index += 1
	if page_index >= len(pages): page_index = 0
	_set_page()


func _on_pause_button_down() -> void:
	Settings.Video_stop_system = !Settings.Video_stop_system
