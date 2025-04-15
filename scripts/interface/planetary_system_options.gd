extends VBoxContainer

@onready var star = $"../../../../TextureRect/SubViewport/System/SpotLight3D"

@onready var PlanetError = $Planet/Error
@onready var PlanetGravitation = $Planet/VBoxContainer/Gravitation
@onready var PlanetWeight = $Planet/VBoxContainer/Weight

@onready var StarError = $Star/Error
@onready var StarActivity = $Star/VBoxContainer/Activity

const page_name: String = "планетарная система🌌"
const presets = ["earth", "mars"]


func _ready() -> void:
	# получение значений
	PlanetGravitation.set_text(str(Settings.SystemPlanet_gravitation))
	PlanetWeight.set_text(str(Settings.SystemPlanet_weight))
	StarActivity.set_text(str(Settings.SystemStar_activity))


# изменение присета планеты
func _on_preset_planet_item_selected(index: int) -> void:
	Settings.Planet_preset = presets[index]
	Settings.read_planet_file()
	_on_planet_button_down()


# изменение значения гравитации планеты
func _on_planet_gravitation_text_changed() -> void:
	if len(PlanetGravitation.get_text()) > 0 and "\n" in PlanetGravitation.get_text():
		PlanetGravitation.set_text(PlanetGravitation.get_text().replace("\n", ""))
		PlanetGravitation.release_focus()

func _on_planet_gravitation_text_set() -> void:
	if not PlanetGravitation.get_text().is_valid_float() or float(PlanetGravitation.get_text()) <= 0:
		Settings.set_error(PlanetError, "Сила гравитации должна быть числом больше 0")
	else:
		Settings.set_error(PlanetError)
		Settings.SystemPlanet_gravitation = float(PlanetGravitation.get_text())


# изменение значения массы планеты
func _on_planet_weight_text_changed() -> void:
	if len(PlanetWeight.get_text()) > 0 and "\n" in PlanetWeight.get_text():
		PlanetWeight.set_text(PlanetWeight.get_text().replace("\n", ""))
		PlanetWeight.release_focus()

func _on_planet_weight_text_set() -> void:
	if not PlanetWeight.get_text().is_valid_float() or float(PlanetWeight.get_text()) <= 0:
		Settings.set_error(PlanetError, "Масса должна быть числом больше 0")
	else:
		Settings.set_error(PlanetError)
		Settings.SystemPlanet_weight = float(PlanetWeight.get_text())


# изменение активности звезды
func _on_star_activity_text_changed() -> void:
	if len(StarActivity.get_text()) > 0 and "\n" in StarActivity.get_text():
		StarActivity.set_text(StarActivity.get_text().replace("\n", ""))
		StarActivity.release_focus()

func _on_star_activity_text_set() -> void:
	if not StarActivity.get_text().is_valid_float() or float(StarActivity.get_text()) <= 0:
		Settings.set_error(StarError, "Активность должна быть числом больше 0")
	else:
		Settings.set_error(StarError)
		Settings.emit_signal("changing_SystemStar_activity", float(StarActivity.get_text()))


# сброс настроек планеты
func _on_planet_button_down() -> void:
	Settings.read_planet_file()
	PlanetGravitation.set_text(str(Settings.SystemPlanet_gravitation))
	PlanetWeight.set_text(str(Settings.SystemPlanet_weight))


# сброс настроек звезды
func _on_star_button_down() -> void:
	StarActivity.set_text("1")
