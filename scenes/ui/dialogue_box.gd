class_name DialogueBox
extends CanvasLayer

@export var lines: Array[String]= []

@onready var dialogue_label: Label = $Border/MarginContainer/Contents/MarginContainer/VBoxContainer/DialogueLabel

var current_line := 0

func start_dialogue():
	visible = true
	dialogue_label.text = lines[current_line]

func end_dialogue():
	visible = false
	EntityManager.dialogue_finished.emit()
	
func refresh() -> void:
	dialogue_label.text = lines[current_line]

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event.is_action_pressed("attack") or event.is_action_pressed("jump"):
		current_line += 1
		if current_line >= lines.size():
			end_dialogue()
		else:
			refresh()
