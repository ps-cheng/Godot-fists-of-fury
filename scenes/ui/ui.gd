class_name UI
extends CanvasLayer

@onready var player_health_bar: Healthbar = $UIContainer/PlayerHealthBar
@onready var enemy_avatar: TextureRect = $UIContainer/EnemyAvatar
@onready var enemy_health_bar: Healthbar = $UIContainer/EnemyHealthBar

const avatar_map : Dictionary = {
	Character.Type.GOON: preload("res://assets/art/ui/avatars/avatar-goon.png"),
	Character.Type.PUNK: preload("res://assets/art/ui/avatars/avatar-punk.png"),
	Character.Type.THUG: preload("res://assets/art/ui/avatars/avatar-thug.png"),
	Character.Type.BOUNCER: preload("res://assets/art/ui/avatars/avatar-boss.png")
}

func _init() -> void:
	DamageManager.health_change.connect(on_character_health_change.bind())
	
func _ready() -> void:
	enemy_avatar.visible = false
	enemy_health_bar.visible = false
	
func on_character_health_change(type: Character.Type, current_health: int, max_health: int) -> void:
	if type == Character.Type.PLAYER:
		player_health_bar.refresh(current_health, max_health)
	else:
		enemy_avatar.texture = avatar_map[type]
		enemy_health_bar.refresh(current_health, max_health)
		enemy_avatar.visible = true
		enemy_health_bar.visible = true
