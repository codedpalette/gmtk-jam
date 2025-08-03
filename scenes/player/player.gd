class_name Player extends CharacterBody2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var trail: Trail = $Trail
var active_color: Color = Color.LIGHT_BLUE
var active: bool = false:
    set(value):
        active = value
        queue_redraw()

func _draw() -> void:
    var shape: CircleShape2D = collision_shape.shape
    var circle_radius := shape.radius * 1.5
    draw_circle(Vector2.ZERO, circle_radius, Color.BLUE)
    if active:
        draw_circle(Vector2.ZERO, circle_radius, active_color, false, 1.0, true)

func _ready() -> void:
    trail.modulate = active_color
    trail.modulate.a = 0.8

func _physics_process(_delta: float) -> void:
    if Engine.is_editor_hint():
        return
    move_and_slide()

func appear(duration: float) -> void:
    trail.clear()
    visible = true
    modulate.a = 0.0
    var tween := create_tween()
    tween.tween_property(self, "modulate:a", 1.0, duration)

func disappear(duration: float) -> void:
    var tween := create_tween()
    tween.tween_property(self, "modulate:a", 0.0, duration)
    tween.tween_callback(func() -> void:
        velocity = Vector2.ZERO
        visible = false
    )

func die() -> void:
    visible = false
