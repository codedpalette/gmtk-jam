class_name Beat extends Node2D

const BPM = 120
const BEAT_DURATION = 60.0 / BPM

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var timer: Timer = $Timer

var current_beat: int = -1
var beat_step: float
var max_beats: int

func _draw():
    var circle_position := Vector2((current_beat + 0.5) * beat_step, 0)
    var circle_radius := 5
    draw_circle(circle_position, circle_radius, Color.RED)

func _ready():
    timer.wait_time = BEAT_DURATION
    timer.timeout.connect(_on_timer_timeout)
    timer.start()

func _on_timer_timeout():
    current_beat += 1
    current_beat %= max_beats
    queue_redraw()
    if current_beat % 2 == 0:
        audio_player.play()