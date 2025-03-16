extends Control

func _ready():
	Globals.first_run = true
	Globals.completed_runs = 0
	$CanvasLayer/VBoxContainer/Button.grab_focus()

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/start_menu.tscn")
