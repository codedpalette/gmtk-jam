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
			cell.clicked.connect(_on_cell_clicked)
			add_child(cell)
			cells.append(cell)

func _on_cell_clicked(column: int, row: int):
	for cell in get_column(column):
		if cell.grid_index.y != row:
			cell.active = false
		else:
			cell.active = !cell.active

func get_cell(row: int, column: int) -> Cell:
	return cells[column * ROWS + row]

func get_column(column: int) -> Array[Cell]:
	return cells.slice(column * ROWS, (column + 1) * ROWS)

func get_row(row: int) -> Array[Cell]:
	return cells.slice(row, cells.size() - (ROWS - row - 1), ROWS)
