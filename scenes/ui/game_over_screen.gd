class_name GameOverScreen
extends Control

@onready var score_indicator: ScoreIndicator = $Background/MarginContainer/VBoxContainer/Score/ScoreIndicator
@onready var timer: Timer = $Timer
@onready var restart_button: Button = $Background/MarginContainer/VBoxContainer/Buttons/RestartButton
@onready var end_button: Button = $Background/MarginContainer/VBoxContainer/Buttons/EndButton

var total_score := 0

func _ready() -> void:
	timer.timeout.connect(on_timer_timeout.bind())
	
func set_score(score: int) -> void:
	total_score = score
	
func on_timer_timeout() -> void:
	score_indicator.add_points(total_score)

func on_restart() -> void:
	get_tree().reload_current_scene()

func on_end() -> void:
	get_tree().quit()
