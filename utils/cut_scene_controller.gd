class_name CutSceneController
extends Node

const BAR_TWEEN_DURATION := 0.3
const CAMERA_TWEEN_DURATION := 0.5

@onready var dialogue_box: DialogueBox = $DialogueBox
@onready var top_bar: ColorRect = $CinematicBars/TopBar
@onready var bottom_bar: ColorRect = $CinematicBars/BottomBar

var player: Player
var boss: IgorBoss
var camera: Camera2D
var is_started := false

func set_player(playerRef) -> void:
	player = playerRef
	try_start()
	
func set_boss(bossRef) -> void:
	boss = bossRef
	try_start()

func try_start() -> void:
	if is_started:
		return
	if player != null and boss != null:
		is_started = true
		start_cutscene()

func start_cutscene() -> void:
	camera = get_viewport().get_camera_2d()
	await lock_player()
	await cinematic_start()
	await boss_entry()
	await dialogue()
	await finish()

func lock_player() -> void:
	player.set_process(false)
	player.set_physics_process(false)
	
func cinematic_start() -> void:
	top_bar.visible = true
	bottom_bar.visible = true
	EntityManager.cutscene_started.emit()
	var bar_height := top_bar.size.y
	var viewport_height := get_viewport().get_visible_rect().size.y
	var tween = create_tween().set_parallel()
	tween.tween_property(top_bar, "position:y", 0.0, BAR_TWEEN_DURATION).from(-bar_height)
	tween.tween_property(bottom_bar, "position:y", viewport_height - bar_height, BAR_TWEEN_DURATION).from(viewport_height)
	await tween.finished

func boss_entry() -> void:
	boss.projectile_aim.enabled = false
	while not boss.is_player_within_range():
		camera.position.x = (player.position.x + boss.position.x) / 2.0
		await get_tree().process_frame
	camera.position.x = (player.position.x + boss.position.x) / 2.0
	boss.projectile_aim.enabled = true
	boss.set_process(false)
	boss.set_physics_process(false)
	
func dialogue() -> void:
	dialogue_box.start_dialogue()
	await EntityManager.dialogue_finished

func finish() -> void:	
	var bar_height := top_bar.size.y
	var viewport_height := get_viewport().get_visible_rect().size.y
	var tween = create_tween().set_parallel()
	tween.tween_property(top_bar, "position:y", -bar_height, BAR_TWEEN_DURATION)
	tween.tween_property(bottom_bar, "position:y", viewport_height, BAR_TWEEN_DURATION)
	tween.tween_property(camera, "position:x", player.position.x, CAMERA_TWEEN_DURATION)
	await tween.finished
	
	EntityManager.cutscene_finished.emit()
	top_bar.visible = false
	bottom_bar.visible = false
	player.set_process(true)
	player.set_physics_process(true)
	boss.set_process(true)
	boss.set_physics_process(true)
