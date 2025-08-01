@tool
class_name Player extends CharacterBody2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _draw():
    var circle_radius = collision_shape.shape.radius
    draw_circle(Vector2.ZERO, circle_radius, Color.BLUE)

func _physics_process(_delta):
    if Engine.is_editor_hint():
        return
    move_and_slide()