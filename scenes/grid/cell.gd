@tool
class_name Cell extends Node2D

@export var line_color: Color
@export var hover_color: Color
@export var clicked_color: Color
const cell_scene: PackedScene = preload("res://scenes/grid/cell.tscn")

@onready var area: Area2D = $Area2D
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D

var rect: Rect2
var grid_index: Vector2i

var hovered: bool = false:
    set(value):
        if hovered != value:
            hovered = value
            queue_redraw()
var active: bool = false:
    set(value):
        if active != value:
            active = value
            queue_redraw()
var center: Vector2:
    get:
        return position + rect.size * 0.5

signal clicked(column: int, row: int)

func _draw() -> void:
    if hovered or active:
        var color := clicked_color if active else hover_color
        draw_rect(rect, color, true)
    draw_rect(rect, line_color, false, 1.0, true)

func _ready() -> void:
    var shape: RectangleShape2D = collision_shape.shape
    shape.size = rect.size
    area.position = rect.size * 0.5
    area.mouse_entered.connect(func() -> void: hovered = true)
    area.mouse_exited.connect(func() -> void: hovered = false)
    area.input_event.connect(func(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void: _on_input_event(event))

func _on_input_event(event: InputEvent) -> void:
    var mouse_event := event as InputEventMouseButton
    if mouse_event != null and mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
        clicked.emit(grid_index.x, grid_index.y)

static func create_cell(width: float, height: float, row: int, column: int) -> Cell:
    var cell: Cell = cell_scene.instantiate()
    cell.position = Vector2(column * width, row * height)
    cell.rect = Rect2(Vector2.ZERO, Vector2(width, height))
    cell.grid_index = Vector2i(column, row)
    return cell
