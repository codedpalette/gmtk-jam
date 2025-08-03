class_name MuteZone extends Area2D

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
    var start_line := Vector2(0, -1).rotated(-PI / 5).normalized() * radius
    var end_line := -start_line
    draw_line(start_line, end_line, debug_color, thickness, true)

func _ready() -> void:
    area_entered.connect(_on_area_entered)
    sprite.modulate = collision_shape.debug_color
    sprite.modulate.a = 1

func _on_area_entered(area: Area2D) -> void:
    var cell := area.get_parent() as Cell
    if cell != null:
        cell.disable()
