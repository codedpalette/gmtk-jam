@tool
class_name Level extends Node2D

var grid: Grid = preload("res://scenes/grid/grid.tscn").instantiate()
var player_scene: PackedScene = preload("res://scenes/player/player.tscn")
var player_pool: Array[Player] = []
var active_player: Player
var inactive_player: Player

var exit_scene: PackedScene = preload("res://scenes/levels/exit_area.tscn")
var exit_area: ExitArea

# TODO: Move to static fields
var _viewport_width: int = ProjectSettings.get_setting("display/window/size/viewport_width")
var _viewport_height: int = ProjectSettings.get_setting("display/window/size/viewport_height")
var viewport_size := Vector2i(_viewport_width, _viewport_height)

signal level_completed()

@export_range(0, Grid.ROWS - 1) var start_row := 0:
    set(value):
        start_row = value
        if Engine.is_editor_hint():
            queue_redraw()
@export_range(0, Grid.ROWS - 1) var exit_row := 0:
    set(value):
        exit_row = value
        if exit_area != null:
            exit_area.position = _get_exit_position(exit_row)

func _draw() -> void:
    if Engine.is_editor_hint():
        var start_position := grid.to_global(_get_starting_position(start_row))
        draw_circle(start_position, 10, Color.RED)

func _ready() -> void:
    _init_player_pool()
    grid.position = viewport_size * 0.5
    add_child(grid)
    _init_players()
    _init_exit_area()
    Beat.beat_triggered.connect(_on_beat_triggered)
    Beat.start()

func _init_player_pool() -> void:
    if player_pool.size() == 0:
        for i in range(2):
            var player_instance: Player = player_scene.instantiate()
            player_pool.append(player_instance)

func _init_players() -> void:
    for player in player_pool:
        player.visible = false
        player.position = _get_starting_position(start_row)
        grid.add_child(player)
    active_player = player_pool[0]
    active_player.active = true
    inactive_player = player_pool[1]
    inactive_player.active = false

func _init_exit_area() -> void:
    if exit_area == null:
        exit_area = exit_scene.instantiate()
    exit_area.position = _get_exit_position(exit_row)
    grid.add_child(exit_area)
    exit_area.size = Vector2(grid.cell_width, grid.cell_height) * 1.1
    exit_area.player_entered.connect(_on_player_entered)

func _on_player_entered(player: Player) -> void:
    if player.visible:
        print("level completed")
        level_completed.emit()

func _on_beat_triggered(beat_index: int) -> void:
    if beat_index == 0:
        _swap_players()
    if beat_index == 6:
        inactive_player.visible = true
    if beat_index == 1:
        inactive_player.visible = false
        inactive_player.velocity = Vector2.ZERO
        inactive_player.position = _get_starting_position(start_row)
    if active_player != null && active_player.visible:
        active_player.velocity = _calculate_player_velocity(active_player, beat_index)
        AudioPlayer.play_beat_note(grid, beat_index)
    else:
        AudioPlayer.stop_beat_note()
    if inactive_player != null && inactive_player.visible:
        var inactive_index: int = beat_index - grid.COLUMNS if beat_index > 4 else grid.COLUMNS
        inactive_player.velocity = _calculate_player_velocity(inactive_player, inactive_index)

func _calculate_player_velocity(player: Player, beat_index: int) -> Vector2:
    var vector_right := Vector2(grid.cell_width / Beat.EIGHTH_NOTE_DURATION, 0)
    var nearest_cell: Cell = null
    for i in range(max(0, beat_index), grid.COLUMNS):
        var column := grid.get_column(i)
        var note_index := column.find_custom(func(cell: Cell) -> bool: return cell.active)
        if note_index >= 0:
            var cell := grid.get_cell(note_index, i)
            if player not in cell.area.get_overlapping_bodies():
                nearest_cell = cell
                break
    if nearest_cell == null:
        return vector_right
    
    var distance := nearest_cell.center - player.position
    var time: float = max(1, nearest_cell.grid_index.x - beat_index) * Beat.EIGHTH_NOTE_DURATION
    return distance / time

func _get_starting_position(row: int) -> Vector2:
    return grid.get_cell(Grid.ROWS - row - 1, 0).center + Vector2(grid.cell_width * -2, 0)

func _get_exit_position(row: int) -> Vector2:
    return grid.get_cell(Grid.ROWS - row - 1, Grid.COLUMNS - 1).center + Vector2(grid.cell_width * 2, 0)

func _swap_players() -> void:
    active_player.active = false
    inactive_player.active = true
    var temp := active_player
    active_player = inactive_player
    inactive_player = temp
