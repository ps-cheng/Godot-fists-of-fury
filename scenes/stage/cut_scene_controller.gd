class_name CutSceneController
extends Node

const CAMERA_TWEEN_DURATION := 0.5

@onready var dialogue_box: DialogueBox = $DialogueBox
@onready var cinematic_bars: CinematicBars = $CinematicBars

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
	lock_player()
	await cinematic_start()
	await boss_entry()
	await dialogue()
	await finish()

func lock_player() -> void:
	player.set_process(false)
	player.set_physics_process(false)
	
func cinematic_start() -> void:
	EntityManager.cutscene_started.emit()
	await cinematic_bars.animate_in()

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
	await cinematic_bars.animate_out()	
	EntityManager.cutscene_finished.emit()
	player.set_process(true)
	player.set_physics_process(true)
	boss.set_process(true)
	boss.set_physics_process(true)
