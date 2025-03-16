extends Control

func _ready():
	$Start/VBoxContainer/StartButton.grab_focus()

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/level_test.tscn")


func _on_controls_button_pressed():
	$Start.visible = false
	$ControlsMenu.visible = true
	$ControlsMenu/VBoxContainer/BackButton.grab_focus()


func _on_back_button_pressed():
	$Start.visible = true
	$ControlsMenu.visible = false
	$Start/VBoxContainer/StartButton.grab_focus()
