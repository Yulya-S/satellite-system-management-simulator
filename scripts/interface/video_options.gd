extends VBoxContainer

@onready var VideoSpeed = $Video/VBoxContainer/Speed
@onready var VideoScale = $Video/VBoxContainer/Scale
@onready var VideoImage = $Video/VBoxContainer/Image
@onready var VideoSaturation = $Video/Saturation

@onready var CameraX = $Camera/VBoxContainer/X
@onready var CameraY = $Camera/VBoxContainer/Y

@onready var ImageBrightness = $Image/VBoxContainer/Brightness
@onready var ImageFog = $Image/VBoxContainer/Fog
@onready var ImageColor = $Image/VBoxContainer/Color

const page_name: String = "Основное⚙"
const factor: int = 5

func _ready() -> void:
	_set_picker()
	
	# применение шага изменения параметров отображения симуляции
	VideoScale.step = factor
	CameraX.step = factor
	CameraY.step = factor
	
	# получение значений из файла настроек
	VideoSpeed.selected = Settings.Video_speed_idx
	VideoScale.value = Settings.Video_scale
	VideoImage.selected = Settings.Video_image_idx
	_on_video_image_item_selected(Settings.Video_image_idx)
	
	VideoSaturation.button_pressed = Settings.Video_show_saturation
	
	CameraX.value = Settings.VideoCamera_x
	CameraY.value = Settings.VideoCamera_y
	
	ImageBrightness.value = Settings.VideoImage_brightness
	ImageFog.value = Settings.VideoImage_fog
	ImageColor.color = Settings.VideoImage_color
	
	# Изменение текстовых значений параметров
	for i in [VideoScale, CameraX, CameraY, ImageBrightness, ImageFog]:
		i.get_child(0).set_text(str(int(i.value)))


# настройка окна выбора цвета
func _set_picker():
	var picker = ImageColor.get_picker()
	ImageColor.color = Settings.VideoImage_color
	picker.picker_shape = 1
	picker.color_modes_visible = false
	picker.sliders_visible = false
	picker.presets_visible = false


# изменение скорости симуляции
func _on_video_speed_item_selected(index: int) -> void:
	Settings.Video_speed_idx = index

# изменение масштаба
func _on_video_scale_value_changed(value: int) -> void:
	VideoScale.get_child(0).set_text(str(value))
	Settings.Video_scale = value
	Settings.emit_signal("changing_Video_scale", value)
	Settings.emit_signal("changing_Video_show_saturation")

# изменение изображения окружения
func _on_video_image_item_selected(index: int) -> void:
	Settings.emit_signal("changing_Video_image_idx", index)

# изменение видимости плотности воздуха
func _on_video_saturation_toggled(toggled_on: bool) -> void:
	Settings.Video_show_saturation = toggled_on
	Settings.emit_signal("changing_Video_show_saturation")


# изменение поворота камеры по X
func _on_camera_x_value_changed(value: int) -> void:
	CameraX.get_child(0).set_text(str(value))
	Settings.VideoCamera_x = value
	Settings.emit_signal("changing_VideoCamera_x", value)

# изменение поворота камеры по Y
func _on_camera_y_value_changed(value: int) -> void:
	CameraY.get_child(0).set_text(str(value))
	Settings.VideoCamera_y = value
	Settings.emit_signal("changing_VideoCamera_y", value)

# сброс настроек поворота камеры
func _on_camera_button_down() -> void:
	Settings.read_config_file("Camera")
	CameraX.value = Settings.VideoCamera_x
	CameraY.value = Settings.VideoCamera_y
	_on_camera_x_value_changed(CameraX.value)
	_on_camera_y_value_changed(CameraY.value)
	
# изменение яркости окружения
func _on_image_brightness_value_changed(value: float) -> void:
	ImageBrightness.get_child(0).set_text(str(value))
	Settings.emit_signal("changing_VideoImage_brightness", value)

# изменение силы тумана
func _on_image_fog_value_changed(value: float) -> void:
	ImageFog.get_child(0).set_text(str(value))
	Settings.emit_signal("changing_VideoImage_fog", value)

func _on_image_color_changed(color: Color) -> void:
	ImageColor.color = color
	Settings.emit_signal("changing_VideoImage_color", color)

# сброс настроек изображения
func _on_image_button_down() -> void:
	Settings.read_config_file("Image")
	ImageBrightness.value = Settings.VideoImage_brightness
	ImageFog.value = Settings.VideoImage_fog
	ImageColor.color = Settings.VideoImage_color
	_on_image_brightness_value_changed(ImageBrightness.value)
	_on_image_fog_value_changed(ImageFog.value)
	_on_image_color_changed(ImageColor.color)
