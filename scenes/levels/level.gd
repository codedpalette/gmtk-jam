@tool
class_name Level extends Node2D

@onready var audio_player: AudioPlayer = $AudioPlayer
@onready var grid: Grid = $Grid
@onready var player: Player = $Grid/Player

func _ready():
    player.position = _get_starting_position() + Vector2(-grid.cell_width, grid.cell_height) * 0.5
    player.velocity = _calculate_player_velocity(0)
    audio_player.grid = grid
    Beat.beat_triggered.connect(_on_beat_triggered)
    Beat.start()

func _on_beat_triggered(beat_index: int):
    if beat_index == 0:
        player.position = _get_starting_position() + Vector2(0, grid.cell_height * 0.5)
    player.velocity = _calculate_player_velocity(beat_index)

func _get_starting_position():
    return grid.get_cell(grid.ROWS - 1, 0).position
    # var cell_global_position = grid.to_global(grid.get_cell(grid.ROWS - 1, 0).position)
    # var local_position = to_local(cell_global_position)
    # return local_position

func _calculate_player_velocity(beat_index: int):
    var nearest_cell: Cell = null
    for i in range(beat_index + 1, grid.COLUMNS):
        var column = grid.get_column(i)
        var note_index = column.find_custom(func(cell: Cell): return cell.active)
        if note_index >= 0:
            nearest_cell = grid.get_cell(note_index, i)
            break

    if nearest_cell == null:
        return Vector2(grid.cell_width / Beat.EIGHTH_NOTE_DURATION, 0)
    
    var distance = nearest_cell.position + Vector2(grid.cell_width, grid.cell_height) * 0.5 - player.position
    var time = (nearest_cell.grid_index.x - beat_index) * Beat.EIGHTH_NOTE_DURATION
    return distance / time
