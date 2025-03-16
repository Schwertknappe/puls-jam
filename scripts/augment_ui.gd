extends CanvasLayer
signal augment_selected(augment_data)

var ui: Node
var current_augments: Array = []

func show_augments(augments: Array):
	
	current_augments = augments
	for i in range(3):
		var panel = $CenterContainer/HBoxContainer.get_child(i)
		panel.set_augment(augments[i])
		panel.visible = true
	visible = true

func _on_augment_selected(augment_data) -> void:
	Globals.chosen_restrictions.append(augment_data)																										
	visible = false
	get_tree().paused = false
	emit_signal("augment_selected", augment_data)
