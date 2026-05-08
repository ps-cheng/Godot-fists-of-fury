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
	while(boss.position.distance_to(player.position) > boss.distance_from_player):
		await get_tree().process_frame
	boss.set_process(false)
	boss.set_physics_process(false)
	
func cinematic_start() -> void:
	var midpoint = (player.position.x + boss.position.x) / 2.0
	top_bar.visible = true
	bottom_bar.visible = true
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
	top_bar.visible = false
	bottom_bar.visible = false
	player.set_process(true)
	player.set_physics_process(true)
	boss.set_process(true)
	boss.set_physics_process(true)
