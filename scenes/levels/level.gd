@tool
class_name Level extends Node2D

@onready var audio_player: AudioPlayer = $AudioPlayer
@onready var grid: Grid = $Grid

var player_scene: PackedScene = preload("res://scenes/player/player.tscn")

var player_pool: Array[Player] = []
var active_player: Player
var inactive_player: Player

func _ready():
    for i in range(2):
        var player_instance: Player = player_scene.instantiate()
        player_instance.visible = false
        player_instance.position = _get_starting_position()
        grid.add_child(player_instance)
        player_pool.append(player_instance)
    active_player = player_pool[0]
    active_player.active = true
    inactive_player = player_pool[1]
    inactive_player.active = false
    audio_player.grid = grid
    Beat.beat_triggered.connect(_on_beat_triggered)
    Beat.start()

func _on_beat_triggered(beat_index: int):
    if beat_index == 0:
        _swap_players()
    if beat_index == 6:
        inactive_player.visible = true
    if beat_index == 1:
        inactive_player.visible = false
        inactive_player.velocity = Vector2.ZERO
        inactive_player.position = _get_starting_position()
    if active_player != null:
        active_player.velocity = _calculate_player_velocity(active_player, beat_index)
    if inactive_player != null && inactive_player.visible:
        var inactive_index = beat_index - grid.COLUMNS if beat_index > 4 else grid.COLUMNS
        inactive_player.velocity = _calculate_player_velocity(inactive_player, inactive_index)

func _swap_players():
    active_player.active = false
    inactive_player.active = true
    var temp = active_player
    active_player = inactive_player
    inactive_player = temp

func _get_starting_position():
    return grid.get_cell(grid.ROWS - 1, 0).center + Vector2(grid.cell_width * -2, 0)

func _calculate_player_velocity(player: Player, beat_index: int):
    var vector_right := Vector2(grid.cell_width / Beat.EIGHTH_NOTE_DURATION, 0)
    var nearest_cell: Cell = null
    for i in range(beat_index, grid.COLUMNS):
        var column = grid.get_column(i)
        var note_index = column.find_custom(func(cell: Cell): return cell.active)
        if note_index >= 0:
            var cell = grid.get_cell(note_index, i)
            if player not in cell.area.get_overlapping_bodies():
                nearest_cell = cell
                break
    if nearest_cell == null:
        # TODO: Snap to grid
        return vector_right
    
    var distance = nearest_cell.center - player.position
    var time = max(1, nearest_cell.grid_index.x - beat_index) * Beat.EIGHTH_NOTE_DURATION
    return distance / time
