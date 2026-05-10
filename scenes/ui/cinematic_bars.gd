class_name CinematicBars
extends CanvasLayer

const BAR_TWEEN_DURATION := 0.3

@onready var top_bar: ColorRect = $TopBar
@onready var bottom_bar: ColorRect = $BottomBar

func animate_in() -> void:
	top_bar.visible = true
	bottom_bar.visible = true
	var bar_height := top_bar.size.y
	var viewport_height := get_viewport().get_visible_rect().size.y
	var tween = create_tween().set_parallel()
	tween.tween_property(top_bar, "position:y", 0.0, BAR_TWEEN_DURATION).from(-bar_height)
	tween.tween_property(bottom_bar, "position:y", viewport_height - bar_height, BAR_TWEEN_DURATION).from(viewport_height)
	await tween.finished
	
func animate_out() -> void:
	var bar_height := top_bar.size.y
	var viewport_height := get_viewport().get_visible_rect().size.y
	var tween = create_tween().set_parallel()
	tween.tween_property(top_bar, "position:y", -bar_height, BAR_TWEEN_DURATION)
	tween.tween_property(bottom_bar, "position:y", viewport_height, BAR_TWEEN_DURATION)
	await tween.finished
	top_bar.visible = false
	bottom_bar.visible = false
