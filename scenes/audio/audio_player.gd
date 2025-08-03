extends Node

@onready var lead_player: AudioStreamPlayer = $LeadPlayer
@onready var drum_loop_player: AudioStreamPlayer = $DrumLoopPlayer
@onready var bass_loop_player: AudioStreamPlayer = $BassLoopPlayer
var pitch_shift_effect: AudioEffectPitchShift = AudioServer.get_bus_effect(1, 1)

func _ready() -> void:
    Beat.beat_triggered.connect(_on_beat_triggered)

var _current_beat := -1
var drum_loop_active := false
var drum_beat_start := -1

func _on_beat_triggered(beat_index: int) -> void:
    if _current_beat == -1:
        fade_in_bass_loop()
    _current_beat = (_current_beat + 1) % 32
    if _current_beat == 0:
        bass_loop_player.play()
    if beat_index == 0 && drum_loop_active:
        drum_beat_start = _current_beat
    if drum_beat_start >= 0 && _current_beat == drum_beat_start:
        drum_loop_player.play()

# Minor
var pitch_shifts := [1.0, 9.0 / 8.0, 6.0 / 5.0, 4.0 / 3.0, 3.0 / 2.0, 8.0 / 5.0, 9.0 / 5.0, 2.0]
# Major
# var pitch_shifts := [1.0, 9.0 / 8.0, 5.0 / 4.0, 4.0 / 3.0, 3.0 / 2.0, 5.0 / 3.0, 15.0 / 8.0, 2.0]

func fade_in_bass_loop() -> void:
    var tween := create_tween()
    var target_volume := bass_loop_player.volume_db
    bass_loop_player.volume_db = -12.0
    tween.tween_property(bass_loop_player, "volume_db", target_volume, Beat.BEAT_DURATION * 2)

func play_beat_note(grid: Grid, beat_index: int) -> void:
    var column := grid.get_column(beat_index)
    var note_index := column.find_custom(func(cell: Cell) -> bool: return cell.active)
    if note_index >= 0:
        pitch_shift_effect.pitch_scale = pitch_shifts[grid.ROWS - note_index - 1]
        lead_player.play()
    else:
        stop_beat_note()

func stop_all_players() -> void:
    lead_player.stop()
    bass_loop_player.stop()
    drum_loop_player.stop()

func stop_beat_note() -> void:
    lead_player.stop()
