class_name StartScreen extends Control

@onready var start_button: Button = $PanelContainer/VBoxContainer/StartButton

func _ready() -> void:
    start_button.pressed.connect(_on_start_button_pressed)

func _on_start_button_pressed() -> void:
    Global.main_controller.change_gui_scene("")
    Global.main_controller.change_world_scene("res://scenes/levels/level.tscn")
