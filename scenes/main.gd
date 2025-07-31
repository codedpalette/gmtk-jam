class_name GameController extends Node

@onready var world: Node2D = $World
@onready var gui: Control = $GUI
@onready var viewport_size: Vector2 = world.get_viewport_rect().size

func _ready() -> void:
    Global.game_controller = self
    world.position = viewport_size * 0.5 # TODO: This logic should be in the level scene
