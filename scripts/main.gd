extends Node2D

@onready var FPS = $CanvasLayer/FPS


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	FPS.text = "FPS: {0}".format([Performance.get_monitor(Performance.TIME_FPS)])
