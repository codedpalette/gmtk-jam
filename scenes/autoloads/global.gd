extends Node

var main_controller: Main

var current_level := -1
var levels_paths: Array[String] = [
    "res://scenes/levels/level.tscn",
]
var finish_screen_path := "res://scenes/gui/finish_screen.tscn"

func advance_level() -> void:
    current_level += 1
    if current_level == 0:
        main_controller.change_gui_scene("")
    if current_level < levels_paths.size():
        main_controller.change_world_scene(levels_paths[current_level])
    else:
        Beat.stop()
        main_controller.change_world_scene("")
        main_controller.change_gui_scene(finish_screen_path)
