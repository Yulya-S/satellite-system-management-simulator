extends Node2D

@onready var FPS = $CanvasLayer/FPS
@onready var PageName = $CanvasLayer/PageName/Label
@onready var InterfaceContainer = $CanvasLayer/InterfaceContainer

var page_index: int = 0
var pages = [load("res://scenes/interface/video_options.tscn"),
			load("res://scenes/interface/Earth_options.tscn"),
			load("res://scenes/interface/Solar_options.tscn")]
var page_names = ["Основное", "Настройки планеты", "Настройки звезды"]


func _ready() -> void:
	#var result = OS.execute("python3", ["path/to/your_script.py"], true)
	_set_page()


func _process(delta: float) -> void:
	FPS.text = "FPS: {0}".format([Performance.get_monitor(Performance.TIME_FPS)])


# смена страницы настроек
func _set_page():
	if len(InterfaceContainer.get_children()) > 0:
		pass
		InterfaceContainer.get_child(0).queue_free()
		InterfaceContainer.remove_child(InterfaceContainer.get_child(0))
	PageName.text = page_names[page_index]
	InterfaceContainer.add_child(pages[page_index].instantiate())
	InterfaceContainer.get_child(-1).custom_minimum_size.x = 347


func _on_left_button_down() -> void:
	page_index -= 1
	if page_index < 0: page_index = len(pages) - 1
	_set_page()


func _on_right_button_down() -> void:
	page_index += 1
	if page_index >= len(pages): page_index = 0
	_set_page()
