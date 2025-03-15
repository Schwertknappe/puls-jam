extends Control

@onready var augment_ui = $AugmentUI
@onready var player = $"../Player"

func _ready():
	show_augment_selection()
	get_tree().paused = true
	$AugmentUI/CenterContainer/HBoxContainer/Augment1/VBoxContainer/Button.grab_focus()

func show_augment_selection():
	var augments = AugmentData.get_random_augments(3)
	augment_ui.show_augments(augments)
	augment_ui.augment_selected.connect(player._on_augment_selected)
