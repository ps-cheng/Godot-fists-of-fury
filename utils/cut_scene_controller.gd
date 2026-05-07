class_name CutSceneController
extends Node

@onready var dialogue_box: DialogueBox = $DialogueBox

var player: Player
var boss: Character
var is_started := false

func set_player(playerRef):
	player = playerRef
	print("set player")
	try_start()
	
func set_boss(bossRef):
	boss = bossRef
	print("set boss")
	try_start()

func try_start():
	if is_started:
		return
	if player != null and boss != null:
		is_started = true
		print("start")
		start_cutscene()

func start_cutscene():	
	await lock_player()
	await boss_entry()
	await dialogue()
	await finish()

func lock_player():
	player.set_process(false)
	player.set_physics_process(false)
	print("lock player")

func boss_entry():
	# simple example
	print("boss entry")
	var target_x = 400
	while boss.position.x > target_x:
		boss.position.x -= 120 * get_process_delta_time()
		await get_tree().process_frame

func dialogue():
	print("dialogue")
	dialogue_box.start_dialogue()
	await EntityManager.dialogue_finished
	print("dialogue")

func finish():
	player.set_process(true)
	player.set_physics_process(true)
	boss.set_process(true)
	boss.set_physics_process(true)
	print("finish")
