extends ColorRect

@onready var v_label = $YLabel
@onready var h_label = $XLabel

var y = []


func _draw() -> void:
	var x_step: float = 1.
	var y_step: float = 1.
	var max_x: float = 10.
	var min_x: float = 1.
	var max_y: float = 10.
	var min_y: float = 0.
	if len(y) > 0:
		max_y = y.max()
		min_y = y.min()
		max_x = len(y)
		x_step = (max_x - min_x) / 10.
		y_step = (max_y - min_y) / 10.
	
	for i in range(11):
		var pos_x = 51. + (355. / 11. * i)
		draw_line(Vector2(pos_x, 10), Vector2(pos_x, 175), Color("e4e4e4"), 2)
		draw_line(Vector2(pos_x, 165), Vector2(pos_x, 175), Color.BLACK, 2)
		draw_string(ThemeDB.fallback_font, Vector2(pos_x - 25, 190), str(min_x + (x_step * i)), 1, 50, 9, Color.BLACK)
	for i in range(11):
		var pos_y = 10. + (176. / 11. * i)
		draw_line(Vector2(51, pos_y), Vector2(375, pos_y), Color("e4e4e4"), 2)
		draw_line(Vector2(46, pos_y), Vector2(56, pos_y), Color.BLACK, 2)
		draw_string(ThemeDB.fallback_font, Vector2(8, pos_y + 5), str(round((max_y - (y_step * i)) * 10) / 10), 1, 50, 10, Color.BLACK)
	if len(y) > 1:
		for i in range(len(y) - 1):
			var x1_pos = 51. + (324. * i / (max_x - 1.))
			var y1_pos = 10. + (160. - (160. * (y[i] - min_y) / (max_y - min_y)))
			var x2_pos = 51. + (324. * (i + 1.) / (max_x - 1.))
			var y2_pos = 10. + (160. - (160. * (y[i + 1] - min_y) / (max_y - min_y)))
			draw_line(Vector2(x1_pos, y1_pos), Vector2(x2_pos, y2_pos), Color.FIREBRICK, 2)


func set_labels(new_h_label: String, new_v_label: String):
	h_label.set_text(new_h_label)
	v_label.set_text(new_v_label)


func update_values(new_y: Array):
	y = new_y
	queue_redraw()
