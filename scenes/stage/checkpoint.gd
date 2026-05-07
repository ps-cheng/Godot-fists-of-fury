class_name Checkpoint
extends Node2D

@export var nb_simultaneous_enemies : int
@export var cutscene_controller : CutSceneController

@onready var enemies: Node2D = $Enemies
@onready var player_detection_area: Area2D = $PlayerDetectionArea

var active_enemy_counter := 0
var enemy_data : Array[EnemyData] = []
var is_activated := false

func _ready() -> void:
	player_detection_area.body_entered.connect(on_player_enter.bind())
	EntityManager.death_enemy.connect(on_enemy_death.bind())
	if cutscene_controller != null:
		EntityManager.boss_spawned.connect(on_boss_spawned.bind())
		
func _process(_delta: float) -> void:
	if is_activated and can_spawn_enemies():
		var enemy : EnemyData = enemy_data.pop_front()
		EntityManager.spawn_enemy.emit(enemy)
		active_enemy_counter += 1
		
func create_enemy_data() -> void:
	for enemy : Character in enemies.get_children():
		enemy_data.append(EnemyData.new(enemy.type, enemy.global_position, enemy.assigned_door_index))
		enemy.queue_free()
		
func can_spawn_enemies() -> bool:
	return enemy_data.size() > 0 and active_enemy_counter < nb_simultaneous_enemies

func on_enemy_death(_enemy: Character) -> void:
	active_enemy_counter -= 1
	if active_enemy_counter == 0 and enemy_data.size() == 0:
		StageManager.checkpoint_complete.emit(self)
		queue_free()

func on_player_enter(player: Player) -> void:
	if not is_activated:
		StageManager.checkpoint_start.emit()
		active_enemy_counter = 0
		is_activated = true
		if cutscene_controller != null:
			cutscene_controller.set_player(player)
		
func on_boss_spawned(boss: Character) -> void:
	if cutscene_controller != null:
		cutscene_controller.set_boss(boss)
