class_name Beat extends Node

const BPM = 120
const BEAT_DURATION = 60.0 / BPM

@onready var kick_player: AudioStreamPlayer = $KickPlayer
@onready var lead_player: AudioStreamPlayer = $LeadPlayer
@onready var timer: Timer = $Timer
var pitch_shift_effect: AudioEffectPitchShift = AudioServer.get_bus_effect(1, 1)

var grid: Grid # TODO: Dependency on grid should be optional
var current_beat: int = -1

signal beat_looped

func _ready():
    timer.wait_time = BEAT_DURATION
    timer.timeout.connect(_on_timer_timeout)
    timer.start()

func _on_timer_timeout():
    current_beat += 1
    current_beat %= grid.COLUMNS
    if current_beat == 0:
        beat_looped.emit()
    if current_beat % 2 == 0:
        kick_player.play()
    _play_beat_note()

var pitch_shifts := [1.0, 9.0 / 8.0, 5.0 / 4.0, 4.0 / 3.0, 3.0 / 2.0, 5.0 / 3.0, 15.0 / 8.0, 2.0]

func _play_beat_note():
    var column := grid.get_column(current_beat)
    var note_index := column.find_custom(func(cell: Cell): return cell.active)
    if note_index >= 0:
        pitch_shift_effect.pitch_scale = pitch_shifts[grid.ROWS - note_index - 1]
        lead_player.play()
    else:
        lead_player.stop()
