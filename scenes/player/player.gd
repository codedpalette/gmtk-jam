class_name Player extends CharacterBody2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
var active: bool = false:
    set(value):
        active = value
        queue_redraw()

func _draw() -> void:
    var shape: CircleShape2D = collision_shape.shape
    var circle_radius := shape.radius
    draw_circle(Vector2.ZERO, circle_radius, Color.BLUE)
    if active:
        draw_circle(Vector2.ZERO, circle_radius, Color.RED, false, 1.0)

func _physics_process(_delta: float) -> void:
    if Engine.is_editor_hint():
        return
    move_and_slide()

func die() -> void:
    visible = false
