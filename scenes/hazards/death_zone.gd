extends Area2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D

func _draw() -> void:
    var debug_color := collision_shape.debug_color
    var shape: RectangleShape2D = collision_shape.shape
    draw_rect(Rect2(-shape.size * 0.5, shape.size), debug_color)
    debug_color.a = 1
    var radius := 25 * sprite.scale.x
    var thickness := 3.0 * sprite.scale.x
    draw_circle(Vector2.ZERO, radius, debug_color, false, thickness, true)

func _ready() -> void:
    body_entered.connect(_on_body_entered)
    sprite.modulate = collision_shape.debug_color
    sprite.modulate.a = 1

func _on_body_entered(body: Node2D) -> void:
    if body is Player:
        (body as Player).die()