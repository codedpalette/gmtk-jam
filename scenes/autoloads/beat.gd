extends Node

const BPM = 128
const BEAT_DURATION = 60.0 / BPM
const EIGHTH_NOTE_DURATION = BEAT_DURATION / 2

@onready var beat_timer: Timer = $BeatTimer
@onready var countdown_timer: Timer = $CountdownTimer

var current_beat := -1
var seconds_elapsed := 0.0

signal beat_triggered(beat_index: int)


func _ready() -> void:
    beat_timer.wait_time = EIGHTH_NOTE_DURATION
    beat_timer.timeout.connect(_on_timeout)
    countdown_timer.timeout.connect(func() -> void: seconds_elapsed += 1)

func start() -> void:
    for timer: Timer in [beat_timer, countdown_timer]:
        if timer.is_stopped():
            timer.start()

func stop() -> void:
    for timer: Timer in [beat_timer, countdown_timer]:
        timer.stop()

func _on_timeout() -> void:
    current_beat = (current_beat + 1) % 8
    beat_triggered.emit(current_beat)
