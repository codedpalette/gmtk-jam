class_name Beat extends Node2D

const BPM = 240
const BEAT_DURATION = 60.0 / BPM

@onready var kick_player: AudioStreamPlayer = $KickPlayer
@onready var lead_player: AudioStreamPlayer = $LeadPlayer
@onready var timer: Timer = $Timer
var pitch_shift_effect: AudioEffectPitchShift = AudioServer.get_bus_effect(1, 1)

var grid: Grid
var current_beat: int = -1

func _draw():
    var circle_position := Vector2((current_beat + 0.5) * grid.cell_width, -grid.cell_height * 0.5)
    var circle_radius := 5
    draw_circle(circle_position, circle_radius, Color.RED)

func _ready():
    timer.wait_time = BEAT_DURATION
    timer.timeout.connect(_on_timer_timeout)
    timer.start()

func _on_timer_timeout():
    current_beat += 1
    current_beat %= grid.COLUMNS
    queue_redraw()
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
