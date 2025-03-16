extends PanelContainer
signal selected(augment_data)

@export var title_label: Label
@export var description_label: Label
@export var icon_texture: TextureRect

# Called when the node enters the scene tree for the first time.
var current_augment: Dictionary

func set_augment(augment: Dictionary):
	current_augment = augment
	title_label.text = augment.title
	description_label.text = augment.description
	icon_texture.texture = augment.icon
	
	
func _on_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.is_pressed():
		selected.emit(current_augment)
		scale = Vector2(0.95, 0.95)
		await get_tree().create_timer(0.1).timeout
		scale = Vector2(1.0, 1.0)


func _on_button_pressed() -> void:
	selected.emit(current_augment)
	scale = Vector2(0.95, 0.95)
	await get_tree().create_timer(0.1).timeout
	scale = Vector2(1.0, 1.0)# Replace with function body.
