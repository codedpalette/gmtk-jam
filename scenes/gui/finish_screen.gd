class_name FinishScreen extends PanelContainer

@onready var stats_label: Label = $VBoxContainer/StatsLabel

func _ready() -> void:
    var total_seconds := int(Beat.seconds_elapsed)
    @warning_ignore("integer_division")
    var minutes := total_seconds / 60
    var seconds := total_seconds % 60
    var minutes_text := "minute" if minutes == 1 else "minutes"
    var seconds_text := "second" if seconds == 1 else "seconds"
    stats_label.text = "And it took you only %d %s and %d %s" % [minutes, minutes_text, seconds, seconds_text]