class_name Cell extends Node2D

@export var line_color: Color = Color(0xfcfcfcff)
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

signal clicked(column: int, row: int)

func _draw():
    if hovered or active:
        var color := clicked_color if active else hover_color
        draw_rect(rect, color, true)
    draw_rect(rect, line_color, false, 1.0)

func _ready():
    collision_shape.shape.size = rect.size
    area.position = rect.size * 0.5
    area.mouse_entered.connect(func(): hovered = true)
    area.mouse_exited.connect(func(): hovered = false)
    area.input_event.connect(func(_viewport, event, _shape_idx): _on_input_event(event))

func _on_input_event(event: InputEvent):
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
        clicked.emit(grid_index.x, grid_index.y)

static func create_cell(width: float, height: float, row: int, column: int) -> Cell:
    var cell: Cell = cell_scene.instantiate()
    cell.position = Vector2(column * width, row * height)
    cell.rect = Rect2(Vector2.ZERO, Vector2(width, height))
    cell.grid_index = Vector2i(column, row)
    return cell
