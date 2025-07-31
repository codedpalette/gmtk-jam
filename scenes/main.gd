class_name GameController extends Node

@onready var world: Node2D = $World
@onready var beat: Beat = $World/Beat
@onready var grid: Grid = $World/Grid
@onready var gui: Control = $GUI
@onready var viewport_size: Vector2 = world.get_viewport_rect().size

func _ready() -> void:
    Global.game_controller = self
    # TODO: This logic should be in the level scene
    world.position = viewport_size * 0.5
    beat.grid = grid
