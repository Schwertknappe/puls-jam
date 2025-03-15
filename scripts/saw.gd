extends Path2D

@export var speed : float = 1
var direction = 1
var moving = true

@onready var path : PathFollow2D = $PathFollow2D
@onready var timer : Timer = $Timer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var new_value = clamp(path.progress_ratio + speed * delta * direction, 0.0, 1.0)
	
	if (new_value == 1.0 or new_value == 0.0) and moving:
		direction *= -1
		timer.start(0.5)
		moving = false
	
	if moving:
		path.progress_ratio = new_value


func _on_timer_timeout():
	moving = true
