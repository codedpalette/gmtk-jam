extends Area2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _draw() -> void:
    var debug_color := collision_shape.debug_color
    var shape: RectangleShape2D = collision_shape.shape
    draw_rect(Rect2(-shape.size * 0.5, shape.size), debug_color)

func _ready() -> void:
    body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
    if body is Player:
        (body as Player).die()