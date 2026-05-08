class_name CutSceneController
extends Node

@onready var dialogue_box: DialogueBox = $DialogueBox
@onready var top_bar: ColorRect = $CinematicBars/TopBar
@onready var bottom_bar: ColorRect = $CinematicBars/BottomBar


var player: Player
var boss: IgorBoss
var camera: Camera2D
var is_started := false

func set_player(playerRef) -> void:
	player = playerRef
	print("set player")
	try_start()
	
func set_boss(bossRef) -> void:
	boss = bossRef
	print("set boss")
	try_start()

func try_start() -> void:
	if is_started:
		return
	if player != null and boss != null:
		is_started = true
		print("start")
		start_cutscene()

func start_cutscene() -> void:
	camera = get_viewport().get_camera_2d()
	await lock_player()
	await boss_entry()
	await cinematic_start()
	await dialogue()
	await finish()

func lock_player() -> void:
	player.set_process(false)
	player.set_physics_process(false)

func boss_entry() -> void:
	boss.projectile_aim.enabled = false
	while not boss.is_player_within_range():
		await get_tree().process_frame
	boss.projectile_aim.enabled = true
	boss.set_process(false)
	boss.set_physics_process(false)
	
func cinematic_start() -> void:
	var midpoint = (player.position.x + boss.position.x) / 2.0
	top_bar.visible = true
	bottom_bar.visible = true
	EntityManager.cutscene_started.emit()
	var tween = create_tween().set_parallel()
	tween.tween_property(top_bar, "position:y", 0.0, 0.3).from(-8.0)
	tween.tween_property(bottom_bar, "position:y", 56.0, 0.3).from(64.0)
	tween.tween_property(camera, "position:x", midpoint, 0.5)
	tween.tween_property(camera, "position:y", 38.0, 0.5)
	await tween.finished
	
func dialogue() -> void:
	dialogue_box.start_dialogue()
	await EntityManager.dialogue_finished

func finish() -> void:
	var tween = create_tween().set_parallel()
	tween.tween_property(top_bar, "position:y", -8.0, 0.3)
	tween.tween_property(bottom_bar, "position:y", 64.0, 0.3)
	tween.tween_property(camera, "position:x", player.position.x, 0.5)
	tween.tween_property(camera, "position:y", 32.0, 0.5)
	await tween.finished
	EntityManager.cutscene_finished.emit()
	top_bar.visible = false
	bottom_bar.visible = false
	player.set_process(true)
	player.set_physics_process(true)
	boss.set_process(true)
	boss.set_physics_process(true)
