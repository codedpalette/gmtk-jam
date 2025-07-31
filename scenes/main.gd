class_name GameController extends Node

@onready var world: Node2D = $World
@onready var beat: Beat = $World/Beat
@onready var grid: Grid = $World/Grid
@onready var player: Player = $World/Player
@onready var gui: Control = $GUI
@onready var viewport_size: Vector2 = world.get_viewport_rect().size

func _ready() -> void:
    Global.game_controller = self
    # TODO: This logic should be in the level scene
    world.position = viewport_size * 0.5
    player.position = grid.to_local(grid.get_cell(grid.ROWS - 1, 0).position) + Vector2(-grid.cell_width, grid.cell_height) * 0.5
    player.horizontal_speed = grid.cell_width / beat.BEAT_DURATION
    beat.grid = grid
    beat.beat_looped.connect(_on_beat_looped)

func _on_beat_looped():
    player.position = grid.to_local(grid.get_cell(grid.ROWS - 1, 0).position) + Vector2(0, grid.cell_height * 0.5)