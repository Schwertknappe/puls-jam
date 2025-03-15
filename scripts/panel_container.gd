extends PanelContainer
signal selected

@export var title_label: Label
@export var description_label: Label
@export var icon_texture: TextureRect

@onready var player := get_node('/root/Player')

# Called when the node enters the scene tree for the first time.
var current_augment: Dictionary

func set_augment(augment: Dictionary):
	current_augment = augment
	title_label.text = augment.title
	description_label.text = augment.description
	icon_texture.texture = augment.icon
	
	
func _on_gui_input(event: InputEvent):
	print("hallo4")
	if event is InputEventMouseButton and event.is_pressed():
		print("hallo3")
		selected.emit(current_augment)
		scale = Vector2(0.95, 0.95)
		await get_tree().create_timer(0.1).timeout
		scale = Vector2(1.0, 1.0)


func _on_button_pressed() -> void:
	print("hallo3")
	selected.emit()
	scale = Vector2(0.95, 0.95)
	await get_tree().create_timer(0.1).timeout
	scale = Vector2(1.0, 1.0)# Replace with function body.
