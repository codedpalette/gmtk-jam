class_name Player extends CharacterBody2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
var active: bool = false:
    set(value):
        active = value
        queue_redraw()

func _draw():
    var circle_radius = collision_shape.shape.radius
    draw_circle(Vector2.ZERO, circle_radius, Color.BLUE)
    if active:
        draw_circle(Vector2.ZERO, circle_radius, Color.RED, false, 1.0)

func _physics_process(_delta):
    if Engine.is_editor_hint():
        return
    move_and_slide()