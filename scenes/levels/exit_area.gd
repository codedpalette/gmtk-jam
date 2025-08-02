@tool
class_name ExitArea extends Area2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var rect_shape: RectangleShape2D = collision_shape.shape

signal player_entered()

var size: Vector2:
    set(value):
        size = value
        rect_shape.size = size

func _draw() -> void:
    var debug_rect := Rect2(size * -0.5, size)
    draw_rect(debug_rect, Color.GREEN, false, 1.0)

func _ready() -> void:
    connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node2D) -> void:
    if body is Player:
        player_entered.emit()