@tool
extends Node

var main_controller: Main
var _viewport_width: int = ProjectSettings.get_setting("display/window/size/viewport_width")
var _viewport_height: int = ProjectSettings.get_setting("display/window/size/viewport_height")
var viewport_size := Vector2i(_viewport_width, _viewport_height)
