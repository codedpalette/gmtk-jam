class_name Grid extends Node2D

const COLUMNS = 8
const ROWS = 7
@export var grid_width: int = 860
@export var grid_height: int = 360

const LINE_COLOR = Color(0xfcfcfcff)

func _draw():
	var cell_width = float(grid_width) / COLUMNS
	var cell_height = float(grid_height) / ROWS

	for column in COLUMNS:
		for row in ROWS:
			var cell_position := Vector2(column * cell_width, row * cell_height) - Vector2(grid_width * 0.5, grid_height * 0.5)
			draw_rect(Rect2(cell_position, Vector2(cell_width, cell_height)), LINE_COLOR, false, 1.0)
