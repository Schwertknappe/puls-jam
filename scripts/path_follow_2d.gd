extends Path2D

@export var speed : float = 1
var direction = 1

@onready var path : PathFollow2D = $PathFollow2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var new_value = clamp(path.progress_ratio + speed * delta * direction, 0.0, 1.0)
	
	if new_value == 1.0 or new_value == 0.0:
		direction *= -1
		
	path.progress_ratio = new_value
