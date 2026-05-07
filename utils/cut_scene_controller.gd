class_name CutSceneController
extends Node2D

var player: Player
var boss: Character
var is_started := false

func set_player(playerRef):
	player = playerRef
	print("set player")
	_try_start()
	
func set_boss(bossRef):
	boss = bossRef
	print("set boss")
	_try_start()

func _try_start():
	if is_started:
		return
	if player != null and boss != null:
		is_started = true
		print("start")
		start_cutscene()

func start_cutscene():	
	await _lock_player()
	await _boss_entry()
	await _dialogue()
	await _finish()

func _lock_player():
	player.set_process(false)
	player.set_physics_process(false)
	print("lock player")

func _boss_entry():
	# simple example
	print("boss entry")
	var target_x = 400
	while boss.position.x > target_x:
		boss.position.x -= 120 * get_process_delta_time()
		await get_tree().process_frame

func _dialogue():
	# placeholder for now
	await get_tree().create_timer(10.0).timeout
	print("dialogue")

func _finish():
	player.set_process(true)
	player.set_physics_process(true)
	boss.set_process(true)
	boss.set_physics_process(true)
	print("finish")
