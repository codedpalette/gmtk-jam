class_name StartScreen extends Control

@onready var start_button: Button = $VBoxContainer/StartButton

func _ready() -> void:
    start_button.pressed.connect(_on_start_button_pressed)

func _on_start_button_pressed() -> void:
    Global.advance_level()
