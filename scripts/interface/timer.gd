extends Node

var hour: int = 0
var minute: int = 0
var second: int = 0

var wait_time: float = 0.
var time_factor: int = 3


func _ready() -> void:
	# получение первоночального значения времени
	var curent_time = Time.get_time_dict_from_system()
	hour = curent_time.hour
	minute = curent_time.minute
	second = curent_time.second


func _process(delta: float) -> void:
	# изменение значения текста
	self.text = ""
	create_text(hour)
	create_text(minute, Settings.Video_speed < 6)
	if Settings.Video_speed < 6: create_text(second, false)

	# шаг времени
	if Settings.Video_speed != 0:
		wait_time += delta
		var wait_time_max = 1. / (time_factor ** (Settings.Video_speed - 1))
		
		if wait_time >= wait_time_max:
			second += floor(wait_time / wait_time_max)
			wait_time -= wait_time_max * floor(wait_time / wait_time_max)
		if second >= 60:
			minute += floor(second / 60.)
			second -= second * floor(second / 60.)
		if minute >= 60:
			hour += floor(minute / 60.)
			minute -= minute * floor(minute / 60.)
		if hour >= 24: hour = 0


# создание значения текста
func create_text(value: int, dots: bool = true):
	if value < 10: self.text += "0"
	self.text += str(value)
	if dots: self.text += ":"
	
