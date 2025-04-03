extends VBoxContainer

@onready var MainImage = $Main/Image
@onready var ImageBrightness = $Image/VBoxContainer/Brightness
@onready var ImageFOV = $Image/VBoxContainer/FOV


func _ready() -> void:
	MainImage.selected = Settings.Environment_idx
	ImageBrightness.value = Settings.Environment_brightness
	ImageFOV.value = Settings.Environment_FOV
	
	ImageBrightness.get_child(0).text = str(ImageBrightness.value)
	ImageFOV.get_child(0).text = str(ceil(ImageFOV.value))

func _on_image_item_selected(index: int) -> void:
	Settings.emit_signal("сhanging_environment", index)
	
func _on_brightness_value_changed(value: float) -> void:
	ImageBrightness.get_child(0).text = str(value)
	Settings.emit_signal("сhanging_environment_brightness", value)
	
func _on_fov_value_changed(value: int) -> void:
	ImageFOV.get_child(0).text = str(ceil(value))
	Settings.emit_signal("сhanging_environment_FOV", int(value))

func _Image_button_down() -> void:
	ImageBrightness.value = 1.0
	ImageFOV.value = 0
	
	ImageBrightness.get_child(0).text = str(ImageBrightness.value)
	ImageFOV.get_child(0).text = str(ceil(ImageFOV.value))
	
	Settings.emit_signal("сhanging_environment_brightness", ImageBrightness.value)
	Settings.emit_signal("сhanging_environment_FOV", ImageFOV.value)
