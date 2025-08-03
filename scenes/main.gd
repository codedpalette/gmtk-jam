class_name Main extends Node

@onready var world: Node2D = $World
@onready var gui: Control = $GUI

var current_world_scene: Node2D
var current_gui_scene: Control

func _ready() -> void:
    Global.main_controller = self
    current_gui_scene = $GUI/StartScreen

func change_gui_scene(new_scene: String, delete := true, keep_running := false) -> void:
    if current_gui_scene != null:
        if delete:
            current_gui_scene.queue_free()
        elif keep_running:
            current_gui_scene.visible = false
        else:
            gui.remove_child(current_gui_scene)
    if new_scene:
        var new_gui_scene := (load(new_scene) as PackedScene).instantiate() as Control
        gui.add_child(new_gui_scene)
        current_gui_scene = new_gui_scene

func change_world_scene(new_scene: String, delete := true, keep_running := false) -> Node2D:
    if current_world_scene != null:
        if delete:
            current_world_scene.queue_free()
        elif keep_running:
            current_world_scene.visible = false
        else:
            world.remove_child(current_world_scene)
    if new_scene:
        var new_world_scene := (load(new_scene) as PackedScene).instantiate() as Node2D
        world.add_child(new_world_scene)
        current_world_scene = new_world_scene
    return current_world_scene