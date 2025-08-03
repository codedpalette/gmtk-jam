@tool
class_name ExitArea extends Area2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var rect_shape: RectangleShape2D = collision_shape.shape

signal player_entered(player: Player)

var color := Color.GREEN
var size: Vector2:
    set(value):
        size = value
        rect_shape.size = size

func _draw() -> void:
    var debug_rect := Rect2(size * -0.5, size)
    draw_rect(debug_rect, color, false, 1.0, true)
    var fill_color := color
    fill_color.a = 0.2
    draw_rect(debug_rect, fill_color)

func _ready() -> void:
    connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node2D) -> void:
    if body is Player:
        player_entered.emit(body as Player)