extends Node

const BPM = 128
const BEAT_DURATION = 60.0 / BPM
const EIGHTH_NOTE_DURATION = BEAT_DURATION / 2

@onready var timer: Timer = $Timer

var current_beat := -1

signal beat_triggered(beat_index: int)

func _ready() -> void:
    timer.wait_time = EIGHTH_NOTE_DURATION
    timer.timeout.connect(_on_timeout)

func start() -> void:
    if timer.is_stopped():
        timer.start()

func stop() -> void:
    timer.stop()

func _on_timeout() -> void:
    current_beat = (current_beat + 1) % 8
    beat_triggered.emit(current_beat)
