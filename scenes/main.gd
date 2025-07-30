class_name GameController extends Node

@onready var world: Node2D = $World
@onready var gui: Control = $GUI

func _ready() -> void:
    Global.game_controller = self