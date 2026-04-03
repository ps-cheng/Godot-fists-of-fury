class_name DeathScreen
extends MarginContainer

@onready var countdown_label: Label = $Border/MarginContainer/Contents/VBoxContainer/CountdownLabel
@onready var timer: Timer = $Timer

@export var countdown_start : int

var current_count := 0

func _ready() -> void:
	current_count = countdown_start
	timer.timeout.connect(on_timer_timeout.bind())
	refresh()
	
func refresh() -> void:
	countdown_label.text = str(current_count)

func on_timer_timeout() -> void:
	if current_count > 0:
		current_count -= 1
		refresh()
	else:
		queue_free()
		
