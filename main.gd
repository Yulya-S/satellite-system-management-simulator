extends Node3D
@onready var CameraNode = $CameraNode/Camera3D/CanvasLayer
var plane = 0 # 0 - x, 1 - y
var turning_speed = 5 # значение на которое изменяется поворот при прокрутке колесика мыши

func _ready() -> void:
	# изначальный поворот камеры над системой
	$CameraNode.rotation_degrees.x = 270
	$CameraNode.rotation_degrees.y = 0
	CameraNode.get_child(4).text = "x: " + str($CameraNode.rotation_degrees.x)\
									+ ", y: " + str($CameraNode.rotation_degrees.y)

func _input(event: InputEvent) -> void:
	if event.is_action("mouse_wheel_up"):
		$CameraNode.rotation_degrees[plane] += turning_speed
		if $CameraNode.rotation_degrees[plane] > 360:
			$CameraNode.rotation_degrees[plane] = 0
	elif event.is_action("mouse_wheel_down"):
		$CameraNode.rotation_degrees[plane] -=  turning_speed
		if $CameraNode.rotation_degrees[plane] < 0:
			$CameraNode.rotation_degrees[plane] = 360
	CameraNode.get_child(4).text = "x: " + str($CameraNode.rotation_degrees.x)\
									+ ", y: " + str($CameraNode.rotation_degrees.y)

func _process(delta: float) -> void:
	var fps = Performance.get_monitor(Performance.TIME_FPS)
	CameraNode.get_child(0).text = "FPS: " + str(fps)
	CameraNode.get_child(1).get_child(0).text = str(CameraNode.get_child(1).value)
	CameraNode.get_child(2).get_child(0).text = str(CameraNode.get_child(2).value)

# переключение
func _on_button_button_down() -> void:
	match plane:
		0:
			plane = 1
			$CameraNode/Camera3D/CanvasLayer/Button.text = "Y"
		1:
			plane = 0
			$CameraNode/Camera3D/CanvasLayer/Button.text = "X"


func _on_center_button_down() -> void:
	$CameraNode.rotation_degrees.x = 270
	$CameraNode.rotation_degrees.y = 0
	
