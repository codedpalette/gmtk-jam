@tool
class_name Level extends Node2D

@onready var beat: Beat = $Beat
@onready var grid: Grid = $Grid
@onready var player: Player = $Player

func _ready():
    player.position = _get_starting_position() + Vector2(-grid.cell_width, grid.cell_height) * 0.5
    player.horizontal_speed = grid.cell_width / beat.BEAT_DURATION
    beat.grid = grid
    beat.beat_looped.connect(_on_beat_looped)

func _on_beat_looped():
    player.position = _get_starting_position() + Vector2(0, grid.cell_height * 0.5)

func _get_starting_position():
    var cell_global_position = grid.to_global(grid.get_cell(grid.ROWS - 1, 0).position)
    var local_position = to_local(cell_global_position)
    return local_position