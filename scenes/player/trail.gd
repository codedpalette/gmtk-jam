class_name Trail extends Line2D

@export var length: float
var point := Vector2.ZERO
var points_cache: Array[Vector2] = []
var phase := 0.0

func _process(delta: float) -> void:
    phase += delta
    global_position = Vector2(0, 0)
    global_rotation = 0

    var parent_position := (get_parent() as Node2D).global_position
    if parent_position.distance_squared_to(point) > 1:
        point = parent_position
        points_cache.append(parent_position)
        add_point(point)
        while get_point_count() > length:
            remove_point(0)
            points_cache.pop_front()

    var point_count := get_point_count()
    if point_count > 2:
        var total_distance := 0.0
        for i in range(1, point_count):
            var previous_point := points_cache[i - 1]
            var current_point := points_cache[i]
            var direction := current_point - previous_point
            total_distance += direction.length()

        var cumulative_distance := 0.0
        for i in range(1, point_count):
            var previous_point := points_cache[i - 1]
            var current_point := points_cache[i]
            var direction := current_point - previous_point
            var orthogonal := direction.orthogonal()
            cumulative_distance += direction.length()
            var normalized_position := cumulative_distance / total_distance
            var offset := orthogonal * sin(phase * 10.0 + normalized_position * PI * 4) * 0.5
            set_point_position(i, current_point + offset)


func clear() -> void:
    clear_points()
    points_cache.clear()
