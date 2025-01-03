extends Node3D
@onready var CameraNode = $CameraNode/Camera3D/CanvasLayer
const base_camera_rotation = -( 90 - 1.57079637050629 ) # разница между предполагаемым и реальным поворотом камеры

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var fps = Performance.get_monitor(Performance.TIME_FPS)
	CameraNode.get_child(0).text = "FPS: " + str(fps)
	CameraNode.get_child(1).get_child(0).text = str(CameraNode.get_child(1).value)
	CameraNode.get_child(2).get_child(0).text = str(CameraNode.get_child(2).value)

func _on_v_slider_value_changed(value: float) -> void:
	$CameraNode.rotation.x = -90 - base_camera_rotation #+ 88.42920362949371
	#print(value)
