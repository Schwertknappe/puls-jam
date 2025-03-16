extends Control
@onready var ui = $UI 

@export var font_paths: Array[String] = [
	"res://assets/fonts/GlitchGoblin.ttf",
	"res://assets/fonts/PixelifySans-Bold.ttf",
	"res://assets/fonts/PixelifySans-VariableFont_wght.ttf",
	"res://assets/fonts/wingding.ttf"
]
@export var min_font_size: int = 10
@export var max_font_size: int = 40

@onready var augment_ui = $AugmentUI
@onready var player = $"../Player"

func _ready():
	update_health_ui()
	player.game_over.connect(game_over)
	player.hit.connect(update_health_ui)
	show_augment_selection()
	get_tree().paused = true
	$AugmentUI/CenterContainer/HBoxContainer/Augment1/Button.grab_focus()

func show_augment_selection():
	var augments = AugmentData.get_random_augments(3)
	augment_ui.ui = $UI
	augment_ui.show_augments(augments)
	augment_ui.augment_selected.connect(player._on_augment_selected)
	player.restriction_added.connect(update_restriction_ui)

	for i in range(3):
		var panel = $AugmentUI/CenterContainer/HBoxContainer.get_child(i)
		var title_label = panel.get_node("VBoxContainer/Title")
		var description_label = panel.get_node("VBoxContainer/Description")

		print("Titel-Label gefunden:", title_label != null)
		print("Beschreibung-Label gefunden:", description_label != null)

		apply_random_font(title_label, 24)
		apply_random_font(description_label, 18)

func game_over():
	get_tree().paused = true
	$GameOver.visible = true
	$GameOver/VBoxContainer/Button.grab_focus()

func update_health_ui():
	$HUD/Health/Heart3.visible = player.lives_left >= 3
	$HUD/Health/Heart2.visible = player.lives_left >= 2
	$HUD/Health/Heart1.visible = player.lives_left >= 1

func update_restriction_ui():
	if not $HUD/Restrictions.visible:
		$HUD/Restrictions.visible = true
	
	if Globals.chosen_restrictions.size() >= 1:
		$HUD/Restrictions/MarginContainer/VBoxContainer/Icon1.visible = true
		$HUD/Restrictions/MarginContainer/VBoxContainer/Icon1.texture = Globals.chosen_restrictions[0].icon
	
	if Globals.chosen_restrictions.size() >= 2:
		$HUD/Restrictions/MarginContainer/VBoxContainer/Icon2.visible = true
		$HUD/Restrictions/MarginContainer/VBoxContainer/Icon2.texture = Globals.chosen_restrictions[1].icon
	
	if Globals.chosen_restrictions.size() >= 3:
		$HUD/Restrictions/MarginContainer/VBoxContainer/Icon3.visible = true
		$HUD/Restrictions/MarginContainer/VBoxContainer/Icon3.texture = Globals.chosen_restrictions[2].icon

func _on_game_over_button_pressed():
	Globals.first_run = true
	Globals.completed_runs = 0
	Globals.chosen_restrictions = []
	get_tree().reload_current_scene()
	
func apply_random_font(label: Label, font_size: int):
	if !label:
		print("label null")
		return
	var new_font = load(font_paths.pick_random())
	var dynamic_font = new_font.duplicate()
	
	label.add_theme_font_override("font", dynamic_font)
	label.add_theme_font_size_override("font_size", font_size)
