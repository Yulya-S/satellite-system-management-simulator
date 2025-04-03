extends Node2D

@onready var FPS = $CanvasLayer/FPS
@onready var PageName = $CanvasLayer/ColorRect/PageName/Label
@onready var InterfaceContainer = $CanvasLayer/ColorRect/InterfaceContainer

# страницы настроек
const pages = ["video_options", "adding_objects", "Earth_options", "Solar_options"]
var page_index: int = 0


func _ready() -> void: PageName.set_text(InterfaceContainer.get_child(0).page_name.to_upper())


func _process(_delta: float) -> void:
	# отображение количества кадров в секунду
	FPS.set_text("FPS: " + str(Performance.get_monitor(Performance.TIME_FPS)))


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
