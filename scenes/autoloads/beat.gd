extends Timer

const BPM = 120
const BEAT_DURATION = 60.0 / BPM
const EIGHTH_NOTE_DURATION = BEAT_DURATION / 2

var current_beat := -1

signal beat_triggered(beat_index: int)

func _ready():
    wait_time = EIGHTH_NOTE_DURATION
    timeout.connect(_on_timeout)

func _on_timeout():
    current_beat = (current_beat + 1) % 8
    beat_triggered.emit(current_beat)