class_name Healthbar
extends Control

@onready var white_border: ColorRect = $WhiteBorder
@onready var content_background: ColorRect = $ContentBackground
@onready var health_gauge: TextureRect = $HealthGauge

@export var is_inverted : bool

var bar_width := size.x
var content_width := bar_width-2

func refresh(current_health: int, max_health: int) -> void:
	var rev = -1 if is_inverted else 1
	white_border.scale.x = bar_width * rev
	content_background.scale.x = content_width * rev
	health_gauge.scale.x =  (float(current_health) / max_health) * content_width * rev
