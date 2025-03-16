extends Control

@onready var augment_ui = $AugmentUI
@onready var player = $"../Player"

func _ready():
	update_health_ui()
	player.game_over.connect(game_over)
	player.hit.connect(update_health_ui)
	show_augment_selection()
	get_tree().paused = true
	$AugmentUI/CenterContainer/HBoxContainer/Augment1/VBoxContainer/Button.grab_focus()

func show_augment_selection():
	var augments = AugmentData.get_random_augments(3)
	augment_ui.show_augments(augments)
	augment_ui.augment_selected.connect(player._on_augment_selected)

func game_over():
	get_tree().paused = true
	$GameOver.visible = true
	$GameOver/VBoxContainer/Button.grab_focus()

func update_health_ui():
	$HUD/Health/Heart3.visible = player.lives_left >= 3
	$HUD/Health/Heart2.visible = player.lives_left >= 2
	$HUD/Health/Heart1.visible = player.lives_left >= 1


func _on_game_over_button_pressed():
	Globals.first_run = true
	get_tree().reload_current_scene()
