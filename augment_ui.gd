extends CanvasLayer
signal augment_selected(augment_data)

var current_augments: Array = []

func show_augments(augments: Array):
	current_augments = augments
	for i in range(2):
		var panel = $CenterContainer/HBoxContainer.get_child(i)
		panel.set_augment(augments[i])
		panel.visible = true
		
	visible = true
	print("hallo2")
	get_tree().paused = true


func _on_augment_selected() -> void:
	print("hallo")
	visible = false
	get_tree().paused = false
	emit_signal("augment_selected", current_augments)
