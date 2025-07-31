extends Node2D
class_name Grid

const COLUMNS = 8
const ROWS = 7

@export var grid_width: int = 860
@export var grid_height: int = 360

var cell_width: float = float(grid_width) / COLUMNS
var cell_height: float = float(grid_height) / ROWS

var cells: Array[Cell] = []
		
func _ready():
	position = Vector2(grid_width, grid_height) * -0.5
	for column in COLUMNS:
		for row in ROWS:
			var cell = Cell.create_cell(cell_width, cell_height, row, column)
			add_child(cell)
			cells.append(cell)
