extends MeshInstance3D

func _ready() -> void: set_texture("earth_texture")
	
# смена текстуры
func set_texture(texture_name: String):
	var file_path = "res://img/planets/" + texture_name + ".png"
	set_surface_override_material(0, StandardMaterial3D.new())
	get_active_material(0).albedo_texture = load(file_path)
