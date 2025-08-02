extends Node

@onready var kick_player: AudioStreamPlayer = $KickPlayer
@onready var lead_player: AudioStreamPlayer = $LeadPlayer
var pitch_shift_effect: AudioEffectPitchShift = AudioServer.get_bus_effect(1, 1)

var current_grid: Grid

func _ready() -> void:
    Beat.beat_triggered.connect(_on_beat_triggered)

func _on_beat_triggered(beat_index: int) -> void:
    if beat_index % 2 == 0:
        kick_player.play()
    if current_grid != null:
        _play_beat_note(current_grid, beat_index)

var pitch_shifts := [1.0, 9.0 / 8.0, 5.0 / 4.0, 4.0 / 3.0, 3.0 / 2.0, 5.0 / 3.0, 15.0 / 8.0, 2.0]

func _play_beat_note(grid: Grid, beat_index: int) -> void:
    var column := grid.get_column(beat_index)
    var note_index := column.find_custom(func(cell: Cell) -> bool: return cell.active)
    if note_index >= 0:
        pitch_shift_effect.pitch_scale = pitch_shifts[grid.ROWS - note_index - 1]
        lead_player.play()
    else:
        lead_player.stop()
